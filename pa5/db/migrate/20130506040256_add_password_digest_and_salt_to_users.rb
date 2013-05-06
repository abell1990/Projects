class AddPasswordDigestAndSaltToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :salt, :string

    # TODO: initialize password info for registered users before migration
    # User.reset_column_information
  end
end
