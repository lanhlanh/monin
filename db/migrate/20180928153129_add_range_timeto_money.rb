class AddRangeTimetoMoney < ActiveRecord::Migration[5.2]
  def change
    add_column :money, :range_time_id, :integer
  end
end
