class AddPasswordDigestAndSaltToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :salt, :string

    User.reset_column_information

    # Initialize password info for registered users to their down-cased first name
    User.all.each do |user|
      user.password = user.first_name.downcase
      user.save(:validate => false)
    end
  end
end
