class Frontend::ContentController < ::ApplicationController
  layout :resolve_layout

  before_action :set_skin,       :only => [:show, :home, :single]
  before_action :set_skin_files, :only => [:show, :home, :single]
  before_action :set_menu,       :only => [:show, :single]

  def show
    @contents = @menu.contents

    if @contents.count == 1
      @content = @contents.first
      set_meta(@content)
      render_single

    elsif @contents.count > 1
      set_meta(@menu)
      render :file => @skin_files.list.full_path

    else
      render :file => @skin_files.default.full_path
    end
  end

  def single
    @content = Mokio::Content.find(params[:id])
    set_meta(@content)
    render_single
  end

  def home
    @contents = Mokio::Content.where(:home_page => true)
    @content = @contents.first
    set_meta(@content)
    render :file => @skin_files.home.full_path
  end

  #
  # Remove directory path "layout/" dependency
  #
  def _normalize_layout(value)
    value
  end


  protected
    def resolve_layout
      @skin_files.layout.full_path
    end


  private
    def set_menu
      @menu = Mokio::Menu.friendly.find(params[:menu_id])
    end

    def set_skin_files
      @skin_files = @skin.skin_files
    end

    def set_skin
      @skin = Mokio::Skin.active.first
    end

    def render_single
      render :file => eval("@skin_files.#{@content.type.gsub(/Mokio::/, '').tableize.singularize}.full_path")
    end

    def set_meta(obj)
      return unless (obj && obj.meta)
      @meta = {
        title: obj.meta.g_title,
        desc: obj.meta.g_desc,
        keywords: obj.meta.g_keywords,
        author: obj.meta.g_author,
        copyright: obj.meta.g_copyright,
        application_name: obj.meta.g_application_name,
        f_title: obj.meta.f_title,
        f_type: obj.meta.f_type,
        f_image: obj.meta.f_image,
        f_url: obj.meta.f_url,
        f_desc: obj.meta.f_desc
      }
    end
end