class AddSkinFileIdToMokioMenu < ActiveRecord::Migration
  def change
    add_column :mokio_menus, :skin_file_id, :integer
  end
end
