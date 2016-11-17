class History < ActiveRecord::Base
  belongs_to :borrower
  belongs_to :lender

  validates :amount,
    presence: true,
    numericality: true
end
