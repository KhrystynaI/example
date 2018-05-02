class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.boolean :published, default: false
      t.datetime :published_at
      t.belongs_to :autor, index: true
      t.belongs_to :category, index: true, default: 1
      t.timestamps
    end
  end
end
