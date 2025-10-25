class CreateExercises < ActiveRecord::Migration[7.2]
  def change
    create_table :exercises do |t|
      t.string :name, null: false
      t.references :category, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
