require "mokio"
require "carrierwave"
require 'zip'
require 'nokogiri'
require 'rdoc'

module MokioSkins
	#
	# test constants
	#
	module Tests
		SKIN_NAME 		 = "Skin name"
		SKIN_FILE_NAME = "Skin file"
		SKIN_FILE_PATH = "/fixtures/test.zip"
	end
end

require "mokio_skins/engine"
require "mokio_skins/simple_forms"
require "mokio_skins/helpers"
require "mokio_skins/frontend_helpers"