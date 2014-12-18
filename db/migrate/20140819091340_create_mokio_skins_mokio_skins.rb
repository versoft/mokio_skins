class CreateMokioSkinsMokioSkins < ActiveRecord::Migration
  def change
    create_table :mokio_skins do |t|
      t.string :name
      t.boolean :active, :default => false
      t.string :zip_file, :default => nil

      t.timestamps
    end

    create_table :mokio_skin_files do |t|
      t.string :name
      t.string :path, :default => nil
      t.string :type, :default => "unknown"
      t.string :content_type, :default => nil

      t.integer :skin_id, :index => true

      t.timestamps
    end
  end
end
