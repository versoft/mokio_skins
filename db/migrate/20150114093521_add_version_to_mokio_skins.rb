class AddVersionToMokioSkins < ActiveRecord::Migration
  def change
    add_column :mokio_skins, :version, :integer, :default => 1
  end
end
