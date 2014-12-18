module Mokio
  class Skin < ActiveRecord::Base
  	include Mokio::Concerns::Models::Common

  	mount_uploader :zip_file, MokioSkins::ZipUploader

  	has_many :skin_files, :dependent => :destroy

    #
    # save skin name from zip file name
    #
    before_create :resolve_name

    #
    # unzip loaded .zip file and save files inside as Mokio::SkinFile objects
    #
  	after_create 	:unzip

    #
    # remove directory from public/skins
    #
  	after_destroy :clean_files

    #
    # only one skin can be active
    #
  	before_update	:check_active

    #
    # check skin name uniqueness
    #
    validate :validate_new_skin, :on => :create

    #
    # scopes
    #
    scope :active, -> { where(:active => true) }

    #
    # const
    #
    STD_DIRS = %w(css images js templates)
    REQUIREMENTS = %w(zip_name_skin_name uniq_name only_css_html only_js_html image_format_html)

    #
    # class methods
    #
    class << self
      def columns_for_table
        %w(name active updated_at)
      end
    end

  	def editable
  		true
  	end

  	def deletable
  		true
  	end

    def styles
      self.skin_files.styles
    end

    def templates
      self.skin_files.templates
    end

    def javascripts
      self.skin_files.javascripts
    end

    def images
      self.skin_files.images
    end

    def has_styles?
      self.styles.count > 0
    end

    def has_templates?
      self.templates.count > 0
    end

    def has_javascripts?
      self.javascripts.count > 0
    end

    def has_images?
      self.images.count > 0
    end

    def dirs
      %w(templates js css images)
    end

    def <<(file)
      MOKIO_LOG.debug "[MokioSkins] [Skin] Adding new skin file to skin with ID:#{self.id}."
      file.skin_id = self.id
      file.path    = "/public/skins/#{self.name}/#{file.file_type}/#{file.name}"
      result       = true

      if file.image.file
        file.name = file.image.filename
        file.path = "/public/skins/#{self.name}/images/#{file.name}"
        MOKIO_LOG.info "[MokioSkins] [Skin] Adding new image #{file.name} in #{file.path}."
        result = false unless file.save!
        return result
      end

      begin
        if file.valid?
          File.open("#{Rails.root}#{file.path}", "w+") { |f| f.write(file.text) } 
          MOKIO_LOG.info "[MokioSkins] [Skin] Creating new file #{file.name} in #{file.path}."
        end
        result = false unless file.save(:validate => false)
      rescue IOError, Errno::EISDIR => e
        MOKIO_LOG.error "[MokioSkins] [Skin] #{e.message}"
        result = false
      ensure
        MOKIO_LOG.debug "[MokioSkins] [Skin] Adding new skin file to skin finished with status: #{result}."
        return result
      end
    end

    def active_view
      "<div class=\"activebutton\">
        <input type=\"radio\" 
          name=\"radio1\"
          value=\"#{self.id}\"
          #{"checked=\"checked\"" if self.active} 
          class=\"activebtn switch-small\"
          data-on=\"success\"
          data-off=\"danger\"
          data-on-label=\"<i class='icomoon-icon-checkmark white'></i>\" 
          data-off-label=\"<i class='icomoon-icon-cancel-3 white'></i>\"
        >
      </div>"
      .html_safe
    end

    protected

      def name_from_zip
        self.zip_file.filename.gsub(/\.zip/, '')
      end

      def resolve_name
        self.name = name_from_zip
      end

      def is_dir?(name)
        name =~ /^[^.]*$/i
      end


  	private

	  	def unzip
        begin
  	  		Zip::File.open("#{Rails.root}/public/#{self.zip_file.url}") do |zip_file|
            MOKIO_LOG.info "[MokioSkins] [Skin] Reading zip file in '/public/#{self.zip_file.url}}'."
  	  			zip_file.each do |entry|
  					  MOKIO_LOG.info "[MokioSkins] [Skin] Extracting #{entry.name}."

  					  file_path = "/public/skins/#{entry.name}"
  					  filename  = File.basename(file_path)

  					  entry.extract "#{Rails.root}#{file_path}"
  					  
              Mokio::SkinFile.new(:name => filename, :path => file_path, :skin_id => self.id).save! unless is_dir?(filename)
  					end
  	  		end
        rescue Zip::DestinationFileExistsError => e
          MOKIO_LOG.error "[MokioSkins] [Skin] #{e.message}."
          false
        end
	  	end

	  	def clean_files
	  		FileUtils.remove_dir "#{Rails.root}/public/skins/#{self.name}"
        MOKIO_LOG.info "[MokioSkins] [Skin] Removing directory '/public/skins/#{self.name}'."
	  	end

	  	def check_active
	  		Mokio::Skin.active.each {|skin| skin.update(:active => false) } if self.active
	  	end

      def validate_new_skin
        Zip::File.open("#{Rails.root}/public/#{self.zip_file.url}") do |zip_file|
          zip_file.each_with_index do |entry, i|
            if i == 0
              Mokio::Skin.all.each do |skin|
                if skin.name == name_from_zip || "#{skin.name}/" == entry.name
                  errors.add(:zip_file, :uniq_name_error, :name => skin.name)
                  return false
                end
              end
            end
            # else
            #   if is_dir?(entry.name) && !STD_DIRS.include?(entry.name)
            #     errors.add(:zip_file, :skin_structure_error)
            #     return false
            #   end
            # end
          end
        end # end reading zip
      end
  end
end
