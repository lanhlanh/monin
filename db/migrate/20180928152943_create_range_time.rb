class CreateRangeTime < ActiveRecord::Migration[5.2]
  def change
    create_table :range_times do |t|
      t.date :start_time
      t.date :end_time
    end
  end
end
