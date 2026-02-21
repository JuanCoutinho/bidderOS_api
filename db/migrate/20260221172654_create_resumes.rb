class CreateResumes < ActiveRecord::Migration[6.1]
  def change
    create_table :resumes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :filename
      t.tex :content_text
      t.vector{1536} :embedding

      t.timestamps
    end
  end
end
