class Frontend::ContentController < Frontend::BaseController

  before_action :set_skin,       :only => [:show, :home, :single]
  before_action :set_skin_files, :only => [:show, :home, :single]
  before_action :set_menu,       :only => [:show, :single]

  def show
    @contents = @menu.contents.active
    if @menu.skin_file.present?
      render_debug "#{Rails.root}#{@menu.skin_file.path}"
    elsif @contents.count == 1
      @content = @contents.first
      set_meta(@content)
      render_single
    elsif @contents.count > 1
      set_meta(@menu)
      render_debug @skin_files.list.full_path
    else
      render_debug @skin_files.default.full_path
    end
  end

  def single
    begin
      @content = Mokio::Content.active.find(params[:id])
      set_meta(@content)
      render_single
    rescue
      #
      # TODO: prepare 404 page
      # np. render :template => "errors/404", :status => 404, :formats => [:html], layout: true
      #
      redirect_to root_path
    end
  end

  def home
    @contents = Mokio::Content.active.where(:home_page => true)
    @content = @contents.first
    set_meta(@content)
    render_debug @skin_files.home.full_path
  end

  private

    def render_single
      render_debug eval("@skin_files.#{@content.type.gsub(/Mokio::/, '').tableize.singularize}.full_path")
    end
  
    # show debug info if user is signed in
    def render_debug(file)
      begin
        render :file => file
      rescue StandardError => e
        @exception = e
        @tpl = @exception.file_name.split("/").last
        @line = @exception.line_number
        @msg = @exception.message
        @src = @exception.source_extract
        
        if user_signed_in? && Rails.env.production?
          render "rescues/error", layout: "rescues/layout"
        else
          raise e  
        end
      end
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