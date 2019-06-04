class CreateMoneyUserCrazies < ActiveRecord::Migration[5.2]
  def change
    create_table :money_user_crazies do |t|
      t.references :money, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
