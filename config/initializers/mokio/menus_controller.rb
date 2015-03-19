Mokio::MenusController.class_eval do
  
  def menu_params #:doc:
    params[:menu].permit(:name, :subtitle, :seq, :target, :external_link, :css_class, :css_body_class, :main_pic, :follow, :parent_id, :active, :visible, :description, :lang_id, :fake,:skin_file_id, :content_ids => [],:available_module_ids => [],
      :meta_attributes => Mokio::Meta.meta_attributes)
  end
  
end