class CreateFlows < ActiveRecord::Migration
  def change
    create_table :flows do |t|
      t.text :name
      t.text :flowJson

      t.timestamps null: false
    end
  end
end
