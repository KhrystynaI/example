class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.boolean :published, :default => false
      t.belongs_to :autor
      t.timestamps
    end
  end
end
