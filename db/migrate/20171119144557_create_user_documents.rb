class CreateUserDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :user_documents, id: :uuid do |t|
      t.string :passport_number
      t.string :passport
      t.string :pan_number, null: false, default: ''
      t.string :pan, null: false, default: ''
      t.string :aadhar_number, null: false, default: ''
      t.string :aadhar, null: false, default: ''
      t.references :user, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
    add_index :user_documents, :passport_number, unique: true
    add_index :user_documents, :pan_number, unique: true
    add_index :user_documents, :aadhar_number, unique: true
  end
end
