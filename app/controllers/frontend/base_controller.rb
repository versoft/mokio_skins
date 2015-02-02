class Frontend::BaseController < ::ApplicationController
  
  layout :resolve_layout

  before_action :set_objects


  def set_objects
    #init modules Hash with positions
    @modules = {}
    Mokio::ModulePosition.all.each do |pos|
      @modules[pos.name.to_sym] = Array.new
    end

    if params[:menu_id].present?
      @menu = Mokio::Menu.friendly.find(params[:menu_id])
      @menu_static_modules = @menu.available_modules.all
      @menu_static_modules.each do |mod|
        add_module mod
      end
    end

    @always_displayed_modules = Mokio::AvailableModule.always_displayed
    @always_displayed_modules.each do |mod|
      add_module mod
    end
  end

  def add_module(mod)
    # TODO: for now we're ignoring display_from and display_to fields
    return if mod.module_position.nil?
    position = mod.module_position.name.to_sym
    block = mod.static_module
    @modules[position].push block if (@modules[position].exclude?(block) && block.active)
  end

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