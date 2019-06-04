class AddAmountPerUserToMoney < ActiveRecord::Migration[5.2]
  def change
    add_column :money, :amount_per_user, :float
  end
end
