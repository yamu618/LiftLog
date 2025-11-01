class AddIndexesToLiftlog < ActiveRecord::Migration[7.2]
  def change
    add_index :categories, :name, unique: true

    add_index :workouts, :performed_on
    add_index :workouts, [:user_id, :performed_on]

    add_index :exercises, [:name, :category_id, :user_id], unique: true
  end
end
