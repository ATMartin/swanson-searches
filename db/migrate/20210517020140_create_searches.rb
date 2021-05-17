class CreateSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :searches do |t|
      t.string :query, null: false
      t.string :quotes, array: true, null: false, default: []
      t.timestamps
    end
  end
end
