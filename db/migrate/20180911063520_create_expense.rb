class CreateExpense < ActiveRecord::Migration[5.1]
  def change
    create_table :money do |t|
      t.integer :user_id
      t.float :amount
      t.text :description
      t.date :create_at
      t.integer :type_of_money

      t.timestamps
    end
  end
end
