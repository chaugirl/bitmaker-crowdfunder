class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.integer :amount
      t.integer :user_id
      t.integer :reward_id

      t.timestamps
    end
  end
end
