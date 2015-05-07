class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.integer :busy
    end
  end
end
