class Frontend::BaseController < ::ApplicationController
  
  layout :resolve_layout
  
  protected
    #
    # Remove directory path "layout/" dependency
    #
    def _normalize_layout(value)
      value
    end
  
    def resolve_layout
      @skin_files.layout.full_path
    end
  
    def set_menu
      @menu = Mokio::Menu.friendly.find(params[:menu_id])
    end

    def set_skin_files
      @skin_files = @skin.skin_files
    end

    def set_skin
      @skin = Mokio::Skin.active.first
    end
  
end