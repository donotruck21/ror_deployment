class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :borrower, index: true
      t.references :lender, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
