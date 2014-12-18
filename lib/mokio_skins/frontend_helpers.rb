module MokioSkins
  module Frontend
    class HelperMethod
      #
      # method name
      #
      attr_accessor :name

      #
      # key for method description translation
      # every YAML key starts there with mokio_frontend_helpers_descriptions.
      #
      attr_accessor :desc

      #
      # extended method name with arguments
      #
      attr_accessor :args

      #
      # class methods
      #
      class << self
        #
        # set config variable
        #
        def setup!
          Rails.configuration.mokio_frontend_helpers = []
        end

        #
        # get config variable
        #
        def config
          Rails.configuration.mokio_frontend_helpers
        end

        #
        # save module module instance methods as HelperMethod objects to config variable
        #
        def <<(helper)
          helper.instance_methods.each do |method|
            Rails.configuration.mokio_frontend_helpers << HelperMethod.new(method, helper.instance_method(method).source_location)
          end
          
          MOKIO_LOG.debug "[MokioSkins] Registered frontend helpers from #{helper}."
        end
      end

      #
      # HelperMethod contructor
      #
      # == Attributes
      #
      # * +method+ - helper method name
      # * +source+ - helper method source, array[path_to_file, line_number]
      #
      def initialize(method, source)
        @name = method.to_s
        @desc = set_desc(@name)
        @args = parse_method_from_source(source)
      end

      private
        #
        # get method definition line from source file and parse it to have method name with arguments
        #
        def parse_method_from_source(source)
          getNthLine(source.first, source.last).gsub(/.+def /, '').gsub(/\n/, '')
        end

        #
        # key for translation
        #
        def set_desc(name)
          "mokio_frontend_helpers_descriptions.#{name}"
        end

        #
        # get nth line from file in file_path
        #
        def getNthLine(file_path, n)
          line = nil
          File.open(file_path) {|f| n.times {|nr| line = f.gets }}
          line
        end
    end
  end
end

#
# extend Rails::Engine
#
Rails::Engine.class_eval do
  def register_mokio_frontend_helper(mod)
    MokioSkins::Frontend::HelperMethod << mod
  end
end