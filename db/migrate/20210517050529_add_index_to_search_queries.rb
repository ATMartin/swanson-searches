class AddIndexToSearchQueries < ActiveRecord::Migration[6.1]
  def change
    add_index :searches, :query, unique: true
  end
end
