module Mokio
  class SkinsController < Mokio::CommonController

    before_action  :check_active, only: [:update_active]
    
    def index
      @current_records = Mokio::Skin.newest_versions
      super
    end
    
    #
    # only one skin can be active
    #
    def check_active
      Mokio::Skin.active.each {|skin| skin.update(:active => false) }
    end

    private
      def skin_params
        params.require(:skin).permit(:name, :zip_file)
      end
  end
end