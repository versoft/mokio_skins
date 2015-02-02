module MokioSkins
  module Helpers

    #
    # include every css file for active skin
    #
    def include_skin_css_all(options = {})
      html = ""
      @skin.styles.each {|css| html << stylesheet_link_tag("/skins/#{css.skin.ver_name}/css/#{css.name}", options) }
      html.html_safe

    end

    #
    # include specified css file for active skin
    #
    def include_skin_css(file_name, options = {})
      stylesheet_link_tag("/skins/#{@skin.ver_name}/css/#{file_name}", options)
    end

    #
    # include every js file for active skin
    #
    def include_skin_js_all(options = {})
      html = ""
      @skin.javascripts.each {|js| html << javascript_include_tag("/skins/#{js.skin.ver_name}/js/#{js.name}", options) }
      html.html_safe 
    end

    #
    # include specified js file for active skin
    #
    def include_skin_js(file_name, options = {})
      javascript_include_tag("/skins/#{@skin.ver_name}/js/#{file_name}", options)
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
      render :template => "templates/#{@skin.ver_name}/templates/#{template_name}"

    end


    def get_logo_image(file_name,options = {})
      html = ""
      @position = Mokio::ModulePosition.find_by_name('logo')
      @module = @position.static_modules.first
      if @module.active?
        html << @module.content.html_safe
      else
        @path = "/skins/#{@skin.ver_name}/images/#{file_name}"
        html << image_tag(@path,options)
      end
      html.html_safe
    end

    def get_image(file_name,options = {})
      html = ""
      @path = "/skins/#{@skin.ver_name}/images/#{file_name}"
      html << image_tag(@path,options)
      html.html_safe
    end


    # overwrite menu css helper method for skins
    # TODO pozniej zastąpić nowym helperem mokio , który wpełni obsłuży style css

    def build_items_with_css(item, limit, index ,css_c)
      return "" if index > limit || !item.children.present?


      html = "<ul class='#{index == 1 ? css_c[0] :  css_c[1]}'>"
      item.children.order_default.each do |i|

        dropdown_css = " "

        if i.children.present?
          dropdown_css = 'class="dropdown-toggle" data-toggle="dropdown"'
        else
          dropdown_css = " "
        end

        if i.visible && i.active
          html << "<li class='#{ css_c[2]  if i.children.present?} #{"active" if i.slug == params[:menu_id] || i.slug == request.original_fullpath.match(/(\D+\/{1}|\D+)/)[0].gsub('/', '')}'>"

          if i.external_link.blank?
            html << "<a href='/#{i.slug}' #{dropdown_css}>#{i.name}</a>"
          else
            html << "<a href='#{i.external_link}' #{dropdown_css} rel='#{i.follow ? "follow" : "nofollow"}' target='#{i.target.blank? ? '_self' : i.target}'>#{i.name}</a>"
          end
          html << build_items_with_css(i, limit, index + 1,css_c)

          html << "</li>"
        end
      end
      html << "</ul>"
      html.html_safe
    end


  end
end