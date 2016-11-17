class Borrower < ActiveRecord::Base
  has_secure_password
  has_many :histories

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  validates :first_name,
    presence: true

  validates :last_name,
    presence: true

  validates :need_money_for,
    presence: true

  validates :description,
    presence: true

  validates :amount_needed,
    presence: true,
    numericality: true

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: EMAIL_REGEX }

  validates :password,
    presence: true,
    confirmation: true,
    on: :create
end
