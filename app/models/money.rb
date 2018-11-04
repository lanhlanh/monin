class Money < ApplicationRecord
  belongs_to :user
  belongs_to :range_time, optional: true

  enum type_of_money: %i(expense income)

  scope :from_month, -> { where(create_at: Date.current.beginning_of_month..Date.current.end_of_month) }
  scope :by_time, -> (id){ where(range_time_id: id)}
  validate :time_in_future

  before_save :create_range_time

  private

  def create_range_time
    if Money.count < 1
      RangeTime.create! start_time: Date.current
    end
    self.range_time = RangeTime.last
  end

  def time_in_future
    return if Money.count < 1
    if create_at < RangeTime.last.start_time
      errors.add :base, "Chốt sổ rồi, mai tạo lại nhé"
    end
  end
end
