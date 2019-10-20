class ChangeDateToBeDateInArticle < ActiveRecord::Migration[5.2]
  def change
    change_column :articles, :date, :date
  end
end
