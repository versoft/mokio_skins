module Mokio
  class SkinFile < ActiveRecord::Base
    extend CarrierWave::Mount

  	belongs_to :skin, :touch => true

    #
    # directory file type, used also in js
    #
    attr_accessor :file_type

    #
    # file text
    #
    attr_accessor :text

    #
    # remove file after destroy
    #
    after_destroy :remove_file

    #
    # save file type to database
    #
    before_save :resolve_type

    #
    # for image upload
    #
    attr_accessor :image
    
    mount_uploader :image, MokioSkins::ImageUploader

    skip_callback :save, :before, :write_image_identifier

    #
    # IMPORTANT: this callback MUST be placed after :reslove_type
    # move templates to app/view directory, they shouldn't be in public directory for security reasons
    #
    before_create :move_templates

    #
    # validations
    #
    validate :uniq_name, :on => :create

    #
    # scopes
    #
    scope :styles,      -> { where(:type => "css")   }
    scope :javascripts, -> { where(:type => "js")    }
    scope :templates,   -> { where(:type => "html")  }
    scope :images,      -> { where(:type => "image") }

    #
    # const
    #
    STD_FILES = %w(default layout home article pic_gallery mov_gallery contact list contact_success contact_error)
    #
    #
    # class methods
    #
    class << self
      STD_FILES.each do |file_type|
        define_method file_type do
          self.all.each {|file| return file if file.name.split(".").first == file_type }
        end
      end

      def inheritance_column
        "class_type"
      end
    end

    def image_will_change!
      true
    end

    def image_changed?
      true
    end

    def full_path
      "#{Rails.root}#{self.path}"
    end

    def script_type
      case self.name
        when /haml/
          "haml"
        when /slim/
          "slim"
        when /erb/
          "html"
        when /scss/
          "sass"
        when /css/
          "css"
        when /coffee/
          "coffee"
        when /js/
          "js"
      end
    end

    def css?
      self.type == "css"
    end

    def template?
      self.type == "html"
    end

    def js?
      self.type == "js"
    end

    def image?
      self.type == "image"
    end

    def file_content
      text = ""
      begin
        unless self.image?
          text = File.read(self.full_path)
          MOKIO_LOG.debug "[MokioSkins] [SkinFile] Reading file #{self.path}"
        end
      rescue IOError => e
        MOKIO_LOG.error "[MokioSkins] [SkinFile] #{e.message}."
        text = "Cannot read file #{self.name}"
      ensure
        return text
      end
    end

    def dir
      begin
        File.basename(self.path.gsub(/#{self.name}/, ''))
      rescue IOError => e
        MOKIO_LOG.error "[MokioSkins] [SkinFile] #{e.message}."
      end
    end

    def as_json(options)
      { :id => self.id, :name => self.name, :type => self.script_type, :text => self.file_content, :path => self.path.gsub(/\/public/, '') }
    end


    def update(params)
      result = true

      begin
        unless params[:text].blank?
          MOKIO_LOG.debug "[MokioSkins] [SkinFile] Writing to file #{self.path}."
          File.open(self.full_path, "w") { |f| f.write(params[:text]) }
          self.touch
        end

        unless params[:name].blank?
          new_name = self.full_path.gsub(/#{self.name}/, params[:name])
          MOKIO_LOG.debug "[MokioSkins] [SkinFile] Renaming #{self.path} to #{new_name}."
          File.rename(self.full_path, new_name)
          self.path = self.path.gsub(/#{self.name}/, params[:name])
          self.name = params[:name]
          result = false unless self.save!
        end
      rescue IOError => e
        MOKIO_LOG.error "[MokioSkins] [SkinFile] #{e.message}." 
        result = false
      ensure
        return result
      end
    end

    private
      def remove_file
        begin
          MOKIO_LOG.info "[MokioSkins] [SkinFile] Removing file #{self.path}."
          File.delete(self.full_path)
        rescue IOError => e
          MOKIO_LOG.error "[MokioSkins] [SkinFile] #{e.message}." 
        end
      end

      def resolve_type
        if self.name =~ /.css/
          self.type = "css"
        elsif self.name =~ /.html/
          self.type = "html"
        elsif self.name =~ /.js/
          self.type = "js"
        elsif self.name =~ /.jpg/ || self.name =~ /.png/ || self.name =~ /.gif/
          self.type = "image"
        end
      end

      def move_templates
        return unless self.type == "html"
        view_dir = "#{Rails.root}/app/views/templates/#{self.skin.ver_name}"

        unless File.directory?(view_dir)
          FileUtils.mkdir_p(view_dir)
          MOKIO_LOG.debug "[MokioSkins] [SkinFile] Creating directory /app/views/#{self.skin.ver_name}."
        end

        view_dir += "/templates"

        unless File.directory?(view_dir)
          FileUtils.mkdir_p(view_dir)
          MOKIO_LOG.debug "[MokioSkins] [SkinFile] Creating directory /app/views/#{self.skin.ver_name}/templates."
        end
        FileUtils.mv self.full_path, view_dir

        self.path = view_dir.gsub(/#{Rails.root}/, '') + "/#{self.name}"
        MOKIO_LOG.info "[MokioSkins] [SkinFile] File #{self.name} is a template moving to #{self.path} for security reasons."
      end

      def uniq_name
        MOKIO_LOG.debug "[MokioSkins] [SkinFile] Checking uniqueness of skin file name: #{self.name}."
        self.skin.skin_files.each do |file|
          if self.name == file.name
            errors.add(:name, :already_exists, :skin => self.skin.ver_name, :name => self.name)
            return false
          end
        end
      end
  end
end
