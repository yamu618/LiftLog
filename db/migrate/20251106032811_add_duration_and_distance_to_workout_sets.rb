class AddDurationAndDistanceToWorkoutSets < ActiveRecord::Migration[7.2]
  def change
    add_column :workout_sets, :duration, :integer, null: false, default: 0
    add_column :workout_sets, :distance, :float, null: false, default: 0.0
  end
end
