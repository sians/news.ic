class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :headline
      t.string :tag
      t.string :section
      t.string :url
      t.datetime :date
      t.boolean :most_commented
      t.boolean :most_shared
      t.boolean :most_viewed
      t.integer :most_viewed_ranking

      t.timestamps
    end
  end
end
