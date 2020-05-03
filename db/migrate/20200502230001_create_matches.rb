class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.string :and
      t.string :rails
      t.string :generate
      t.string :model
      t.string :game

      t.timestamps
    end
  end
end
