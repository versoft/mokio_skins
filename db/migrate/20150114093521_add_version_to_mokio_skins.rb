class AddVersionToMokioSkins < ActiveRecord::Migration[6.0]
  def change
    add_column :mokio_skins, :version, :integer, :default => 1
  end
end
