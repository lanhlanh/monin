class AddNumOfUserToMoney < ActiveRecord::Migration[5.2]
  def change
    add_column :money, :num_of_user, :integer
  end
end
