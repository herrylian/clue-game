class CreateDices < ActiveRecord::Migration[6.0]
  def change
    create_table :dices do |t|
      t.string :dice, :null => false

      t.timestamps
    end
  end
end
