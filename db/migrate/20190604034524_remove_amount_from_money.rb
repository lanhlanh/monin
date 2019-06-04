class RemoveAmountFromMoney < ActiveRecord::Migration[5.2]
  def change
    remove_column :money, :amount, :float
  end
end
