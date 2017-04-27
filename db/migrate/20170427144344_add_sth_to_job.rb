class AddSthToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :company, :string, default: 'We Health'
    add_column :jobs, :location, :string, default: '福州'
  end
end
