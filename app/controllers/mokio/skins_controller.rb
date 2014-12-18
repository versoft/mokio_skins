module Mokio
	class SkinsController < Mokio::CommonController

		private
			def skin_params
				params.require(:skin).permit(:name, :active, :zip_file)
			end
	end
end