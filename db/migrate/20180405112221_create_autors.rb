class CreateAutors < ActiveRecord::Migration[5.1]
  def change
    create_table :autors do |t|
      t.string :name
      t.string :lastname
      t.string :alias
      t.integer :age
      t.decimal :salary
      t.timestamps
    end
  end
end
