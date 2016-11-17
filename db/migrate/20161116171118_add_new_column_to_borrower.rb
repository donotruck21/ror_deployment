class AddNewColumnToBorrower < ActiveRecord::Migration
  def change
    add_column :borrowers, :amount_raised, :integer
  end
end
