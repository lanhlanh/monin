class RangeTime < ApplicationRecord
  has_many :money

  after_update :create_new_range_time

  def create_new_range_time
    RangeTime.create! start_time: Date.current + 1
  end
end
