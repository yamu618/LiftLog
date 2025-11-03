class RemoveWeightAndRepsFromWorkouts < ActiveRecord::Migration[7.2]
  def change
    remove_column :workouts, :weight, :float
    remove_column :workouts, :reps, :integer
  end
end
