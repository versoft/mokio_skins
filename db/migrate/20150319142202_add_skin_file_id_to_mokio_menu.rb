class AddSkinFileIdToMokioMenu < ActiveRecord::Migration[6.0]
  def change
    add_column :mokio_menus, :skin_file_id, :integer
  end
end
