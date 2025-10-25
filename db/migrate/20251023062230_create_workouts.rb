class CreateWorkouts < ActiveRecord::Migration[7.2]
  def change
    create_table :workouts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.float :weight, null: false, default: 0
      t.integer :reps, null: false, default: 0
      t.date :performed_on, null: false
      t.float :total_weight
      t.float :calculated_1rm

      t.timestamps
    end
  end
end
