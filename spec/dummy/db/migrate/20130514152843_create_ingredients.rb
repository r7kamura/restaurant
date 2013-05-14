class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :title
      t.float :gram
      t.references :recipe

      t.timestamps
    end
    add_index :ingredients, :recipe_id
  end
end
