class AddLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login, :string

    User.reset_column_information

    # Initialize login attribute to downcased user's last name
    User.all.each do |user|
    	user.update_attributes(:login => user.last_name.downcase)
    end
  end
end
