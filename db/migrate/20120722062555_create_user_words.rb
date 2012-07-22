class CreateUserWords < ActiveRecord::Migration
  def change
    create_table :user_words do |t|
      t.references :user
      t.references :word
      t.boolean :new
      t.float :interval
      t.datetime :last_review
      t.datetime :next_due
      t.integer :incorrect_count
      t.integer :correct_count
      t.float :easiness_factor

      t.timestamps
    end
    add_index :user_words, :user_id
    add_index :user_words, :word_id
  end
end
