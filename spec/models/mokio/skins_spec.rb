require 'spec_helper'

module Mokio
  describe Skin do
    before do
      Mokio::Skin.skip_callback(:save, :after, :unzip)
      Mokio::Skin.skip_callback(:destroy, :after, :clean_files)
    end

    before :each do
    	@skin = FactoryGirl.create(:skin)
    end

    context 'Defaults' do
      it "is Mokio::Skin" do
        @skin.should be_a(Mokio::Skin)
      end

      it "is ActiveRecord::Base class" do
        @skin.should be_a(ActiveRecord::Base)
      end

      it "should be valid" do
        @skin.should be_valid
      end

      it "has default active false" do
        @skin.active.should eq(false)
      end

      it "has 'name' method returning name" do
        @skin.name.should eq(MokioSkins::Tests::SKIN_NAME)
      end

      it "has active boolean" do
        @skin.active.should be_a(FalseClass)
      end

      it "is editable" do
        @skin.editable.should eq(true)
      end

      it "is deletable" do
        @skin.deletable.should eq(true)
      end 
    end


    context 'Association' do
      it "has many skin_files" do
        Mokio::Skin.reflect_on_association(:skin_files).macro.should eq(:has_many)
      end

      it "respond to association" do
        @skin.skin_files.should be_a(ActiveRecord::Associations::CollectionProxy)
      end

      it "has skin files" do
        @skin.skin_files.first.should be_a(Mokio::SkinFile)
      end
    end


    context 'ClassMethods' do
      it "has name in columns_for_table" do
        Mokio::Skin.columns_for_table.include?("name").should eq(true)
      end

      it "has active in columns_for_table" do
        Mokio::Skin.columns_for_table.include?("active").should eq(true)
      end

      it "has gmap disabled" do
        Mokio::Skin.has_gmap_enabled?.should eq(false)
      end

      it "has meta disabled" do
        Mokio::Skin.has_meta_enabled?.should eq(false)
      end 
    end
  end
end
