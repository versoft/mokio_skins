module Mokio
  class SkinFilesController < Mokio::BaseController
    before_filter :skin_file, :only => [:edit, :update, :destroy, :change_name]
    before_filter :disable_last_modified, :only => [:new, :edit]

    def new
      @skin = Mokio::Skin.find(params[:skin_id])
      respond_to {|format| format.js}
    end

    def create
      @file = Mokio::SkinFile.new(skin_file_params)

      if Mokio::Skin.find(params[:id]) << @file
        flash[:notice] = t("skin_files.created", :name => @file.name)
        respond_to {|format| format.json { render :json => @file }}
      else
        flash[:error] = @file.errors.first.last unless @file.errors.empty?
        flash[:error] ||= t("skin_files.not_created", :name => @file.name)
        respond_to {|format| format.json { render :json => { :error => "already exists" }}}
      end
    end

    def edit
      respond_to {|format| format.json { render :json => @skin_file }}
    end

    def update
      if @skin_file.update(skin_file_text)
        flash[:notice] = t("skin_files.updated", :name => @skin_file.name)
      else
        flash[:error] = t("skin_files.not_updated", :name => @skin_file.name)
      end

      render :nothing => true
    end

    def destroy
      if @skin_file.destroy
        flash[:notice] = t("skin_files.deleted", :name => @skin_file.name)
      else
        flash[:error] = t("skin_files.not_deleted", :name => @skin_file.name)
      end

      render :nothing => true
    end

    def change_name
      oldname = @skin_file.name

      if @skin_file.update(skin_file_params)
        flash[:notice] = t("skin_files.name_changed", :name => @skin_file.name, :oldname => oldname)
      else
        flash[:error] = t("skin_files.name_not_changed", :name => @skin_file.name, :oldname => oldname)
      end

      render :nothing => true
    end

    def add_image
      @file = Mokio::SkinFile.new(skin_file_params)

      if Mokio::Skin.find(params[:id]) << @file
        flash[:notice] = t("skin_files.created", :name => @file.name)
        respond_to {|format| format.json { render :json => @file }}
      else
        flash[:error] = t("skin_files.not_created", :name => @file.name)
        render :nothing => true
      end
    end

    private
      def skin_file_text
        params.require(:skin_file).permit(:text)
      end

      def skin_file_params
        params.require(:skin_file).permit(:name, :file_type, :text, :image)
      end

      def skin_file
        @skin_file = Mokio::SkinFile.find(params[:id])
      end

      def disable_last_modified
        headers['Last-Modified'] = Time.now.httpdate if Rails.env.development?
      end
  end
end