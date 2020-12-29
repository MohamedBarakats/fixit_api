class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :title
      t.text :note
      t.text :description

      t.timestamps
    end
  end
end
