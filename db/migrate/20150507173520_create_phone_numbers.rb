class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.integer :number
      t.boolean :in_process
      t.integer :last_status
      t.integer :tryouts
      t.timestamp :last_taken
    end
  end
end
