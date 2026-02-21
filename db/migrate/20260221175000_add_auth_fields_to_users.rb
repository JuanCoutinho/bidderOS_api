class AddAuthFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_index :users, :email, unique: true
  end
end
