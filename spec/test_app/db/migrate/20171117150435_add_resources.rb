class AddResources < ActiveRecord::Migration[5.1]
  def change
    create_table :resources do |t|
      t.string :name
    end
  end
end
