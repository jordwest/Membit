class AddUserRoleToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :user_role, :string
  end
end
