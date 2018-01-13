class CreateHoges < ActiveRecord::Migration[5.1]
  def change
    create_table :hoges do |t|
      t.string :name
      t.integer :in
      t.boolean :bl

      t.timestamps
    end
  end
end
