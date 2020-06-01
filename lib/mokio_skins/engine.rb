module MokioSkins
  class Engine < ::Rails::Engine
    initializer :copy_migrations do |app|
      unless app.root.to_s.match root.to_s
        railties = {}
        railties['mokio_skins'] = config.paths["db/migrate"].expanded.first

        on_skip = Proc.new do |name, migration|
          puts "NOTE: Migration #{migration.basename} from #{name} has been skipped. Migration with the same name already exists."
        end

        on_copy = Proc.new do |name, migration|
          puts "\nCopied migration #{migration.basename} from #{name}\n".green + "Run rake db:migrate first!\n".red
        end
        ActiveRecord::Migration.copy(ActiveRecord::Migrator.migrations_paths.first, railties,
                                     :on_skip => on_skip, :on_copy => on_copy)
      end
    end
    
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
