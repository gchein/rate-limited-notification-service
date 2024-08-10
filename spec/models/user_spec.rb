require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'model validations' do
    let(:user) { build(:user) }

    it 'is valid with all required fields' do
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user.name = nil
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

  describe 'model associations' do
    describe 'notifications association' do
      let(:notification_association) { User.reflect_on_association(:notifications) }

      it 'has many notifications' do
        expect(notification_association.macro).to eq(:has_many)
      end

      it 'destroys dependent records' do
        dependent_records_option = notification_association.options[:dependent]
        expect(dependent_records_option).to eq(:destroy)
      end
    end
  end
end
