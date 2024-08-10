class User < ApplicationRecord
  has_many :notifications, dependent: :destroy

  validates :name, :email, presence: true
end
