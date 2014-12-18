module MokioSkins
  module Helpers
    #
    # include every css file for active skin
    #
    def include_skin_css_all(options = {})
      html = ""
      @skin.styles.each {|css| html << stylesheet_link_tag("/skins/#{css.skin.name}/css/#{css.name}", options) }
      html.html_safe
    end

    #
    # include specified css file for active skin
    #
    def include_skin_css(file_name, options = {})
      stylesheet_link_tag("/skins/#{@skin.name}/css/#{file_name}", options)
    end

    #
    # include every js file for active skin
    #
    def include_skin_js_all(options = {})
      html = ""
      @skin.javascripts.each {|js| html << javascript_include_tag("/skins/#{js.skin.name}/js/#{js.name}", options) }
      html.html_safe 
    end

    #
    # include specified js file for active skin
    #
    def include_skin_js(file_name, options = {})
      javascript_include_tag("/skins/#{@skin.name}/js/#{file_name}", options)
    end

    #
    # include jquery
    #
    def include_jquery
      javascript_include_tag("jquery")
    end

    #
    # include jquery ui.core
    #
    def include_jquery_ui
      javascript_include_tag("jquery.ui.core")
    end

    #
    # include meta tags if exists
    #
    def include_meta
      render :partial => "/mokio_skins/meta" if @meta
    end

    #
    # render specific template
    #
    def render_template(template_name)
      render :template => "templates/#{@skin.name}/templates/#{template_name}"
    end
  end
end