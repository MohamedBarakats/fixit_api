class CreatePhoneNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :phone_numbers do |t|
      t.string   :number
      t.boolean  :is_verified
      t.timestamps
    end
    add_reference :phone_numbers, :user, index: true, foreign_key: true
  end
end
