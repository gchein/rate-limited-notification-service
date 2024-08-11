require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'model validations' do
    context 'default validations' do
      let(:notification) { create(:notification) }

      it 'is valid with all required fields' do
        notification = build(:notification)
        expect(notification).to be_valid
      end

      it 'is invalid without a type, with type error notification only' do
        notification.notification_type = nil
        expect(notification).not_to be_valid
        expect(notification.errors[:notification_type]).to include("can't be blank")
        expect(notification.errors.to_hash.keys).to eq([:notification_type])
      end

      it 'is invalid with an incorrect type, with type error notification only' do
        notification.notification_type = 'Invalid Type'
        expect(notification).not_to be_valid
        expect(notification.errors[:notification_type]).to include("is not included in the list")
        expect(notification.errors.to_hash.keys).to eq([:notification_type])
      end

      it 'is invalid without a message, with message error notification only' do
        notification.message = nil
        expect(notification).not_to be_valid
        expect(notification.errors[:message]).to include("can't be blank")
        expect(notification.errors.to_hash.keys).to eq([:message])
      end

      it 'is invalid without a user, with user error notification only' do
        notification.user = nil
        expect(notification).not_to be_valid
        expect(notification.errors[:user]).to include("must exist")
        expect(notification.errors.to_hash.keys).to eq([:user])
      end

      it 'should be destroyed if User is destroyed' do
        user_id = notification.user.id
        User.find(user_id).destroy

        expect { notification.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'custom validations' do
      let(:user) { create(:user) }
      let(:notification_type) { "Status Update" }
      let(:notification_type_sym) { :status_update }

      describe 'can_send_to_user?' do
        it 'should be valid for an empty database' do
          notification = build(:notification)
          expect(notification).to be_valid
        end

        it 'should be invalid when notifications reach max limit' do
          smallest_limit = RATE_LIMIT_RULES[notification_type_sym].each_value.min
          create_list(:notification, smallest_limit, user:, notification_type:)

          notification = build(:notification, user:, notification_type:)

          expect(notification).not_to be_valid
          expect(notification.errors[:base]).to include("Max Notification Limit reached")
        end

        it 'should only trigger when creating, not updating a record' do
          smallest_limit = RATE_LIMIT_RULES[notification_type_sym].each_value.min
          create_list(:notification, smallest_limit, user:, notification_type:)

          notification = Notification.last
          notification.message = "New Message"
          expect(notification).to be_valid
        end
      end
    end
  end

  describe 'model associations' do
    describe 'user association' do
      let(:user_association) { Notification.reflect_on_association(:user) }

      it 'belongs to user' do
        expect(user_association.macro).to eq(:belongs_to)
      end
    end
  end

  describe 'model scopes' do
    let(:user) { create(:user) }
    let(:notification_type) { "Status Update" }
    let(:notification_type_sym) { :status_update }

    describe 'creation_window' do
      context 'with records in the database' do
        it 'should correctly include the records within each time frame' do
          create(:notification, user:, notification_type:)
          create(:notification, user:, notification_type:, created_at: 1.hour.ago + 30.seconds)

          expect(Notification.creation_window(:minute).count).to eq(1)
          expect(Notification.creation_window(:hour).count).to eq(2)
        end
      end

      context 'without records in the database' do
        it 'should return an empty ActiveRecord Relation object' do
          scope_result = Notification.creation_window(:day)

          expect(scope_result.class.superclass).to eq(ActiveRecord::Relation)
          expect(scope_result).to be_empty
        end
      end
    end

    describe 'count_notifications_by_user_and_type' do
      it 'should correctly count notifications by user and type' do
        smallest_limit = RATE_LIMIT_RULES[notification_type_sym].each_value.min
        create_list(:notification, smallest_limit, user:, notification_type:)
        scope_result = Notification.count_notifications_by_user_and_type(user:, notification_type:)

        expect(scope_result).to eq(smallest_limit)
      end

      it 'should return zero if the query does not find any record' do
        scope_result = Notification.count_notifications_by_user_and_type(user:, notification_type:)

        expect(scope_result).to eq(0)
      end
    end
  end
end
