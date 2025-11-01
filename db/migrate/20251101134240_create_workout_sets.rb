class CreateWorkoutSets < ActiveRecord::Migration[7.2]
  def change
    create_table :workout_sets do |t|
      t.references :workout, null: false, foreign_key: true
      t.float :weight, default: 0.0, null: false
      t.integer :reps, default: 0, null: false

      t.timestamps
    end
  end
end
