class MoneyUserCrazy < ApplicationRecord
  belongs_to :money
  belongs_to :user

  validates_presence_of :money_id
  validates_presence_of :user_id
end
