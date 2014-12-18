module MokioSkins
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    #
    # setup mokio frontend helpers before initialize
    #
    config.before_initialize do
      MokioSkins::Frontend::HelperMethod.setup!
    end

    #
    # precompile hook
    #
    initializer "mokio.precompile", group: :all do |app|
      app.config.assets.precompile += %w(mokio_skins/application.css mokio_skins/application.js)
    end

    #
    # load helper to ActionView
    #
    initializer 'mokio_skins.helpers' do
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, MokioSkins::Helpers
      end
    end

    #
    # register mokio frontend helpers
    #
    initializer 'fronend_helpers' do
      #
      # mokio_skins helpers
      #
      register_mokio_frontend_helper MokioSkins::Helpers

      #
      # mokio helpers
      #
      register_mokio_frontend_helper Mokio::FrontendHelpers::MenuHelper
      register_mokio_frontend_helper Mokio::FrontendHelpers::StaticModulesHelper
      register_mokio_frontend_helper Mokio::FrontendHelpers::ContentHelper
      register_mokio_frontend_helper Mokio::FrontendHelpers::ExternalScriptsHelper
    end
  end
end
