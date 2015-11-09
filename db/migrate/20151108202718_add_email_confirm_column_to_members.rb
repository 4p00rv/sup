class AddEmailConfirmColumnToMembers < ActiveRecord::Migration
  def change
    add_column :members, :email_confirmed, :boolean
    add_column :members, :confirm_token, :string
  end
end
