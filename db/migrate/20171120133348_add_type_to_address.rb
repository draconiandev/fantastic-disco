class AddTypeToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :address_type, :string, null: false, default: ''
    add_index  :addresses, :address_type
  end
end
