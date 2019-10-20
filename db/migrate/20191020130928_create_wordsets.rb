class CreateWordsets < ActiveRecord::Migration[5.2]
  def change
    create_table :wordsets do |t|
      t.string :title
      t.string :set

      t.timestamps
    end
  end
end
