class CreateResumes < ActiveRecord::Migration[6.1]
  def change
    create_table :resumes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :filename
      t.text :content_text
      t.column :embedding, :vector, limit: 1536

      t.timestamps
    end
  end
end
