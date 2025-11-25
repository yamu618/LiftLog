class AddBestToExercises < ActiveRecord::Migration[7.2]
  def change
    add_column :exercises, :best_weight, :float
    add_column :exercises, :best_distance, :float
  end
end
