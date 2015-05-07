class CreateActiveCalls < ActiveRecord::Migration
  def change
    create_table :active_calls do |t|
      t.integer :number
      t.integer :agent
      t.integer :duration
    end
  end
end
