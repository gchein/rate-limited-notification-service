require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'model validations' do
    let(:notification) { create(:notification) }

    it 'is valid with all required fields' do
      expect(notification).to be_valid
    end

    it 'is invalid without a type' do
      notification.notification_type = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:notification_type]).to include("can't be blank")
    end

    it 'is invalid with an incorrect type' do
      notification.notification_type = 'Invalid Type'
      expect(notification).not_to be_valid
      expect(notification.errors[:notification_type]).to include("is not included in the list")
    end

    it 'is invalid without a message' do
      notification.message = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:message]).to include("can't be blank")
    end

    it 'is invalid without a user' do
      notification.user = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:user]).to include("must exist")
    end

    it 'should be destroyed if User is destroyed' do
      user_id = notification.user.id
      User.find(user_id).destroy

      expect { notification.reload }.to raise_error(ActiveRecord::RecordNotFound)
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
end
