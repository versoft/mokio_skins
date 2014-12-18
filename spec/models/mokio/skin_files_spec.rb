require 'spec_helper'

module Mokio
  describe SkinFile do
    before :each do
      @skin_file = FactoryGirl.create(:skin_file)
    end

    it "belongs_to skin" do
      Mokio::SkinFile.reflect_on_association(:skin).macro.should eq(:belongs_to)
    end

    it "is Mokio::SkinFile" do
      @skin_file.should be_a(Mokio::SkinFile)
    end

    it "is valid" do
      @skin_file.should be_valid
    end

    it "has content_type default nil" do
      @skin_file.content_type.should eq(nil)
    end

    it "has 'name' method returning name" do
      @skin_file.name.should eq(MokioSkins::Tests::SKIN_FILE_NAME)
    end

    it "has 'path' method returning path" do
      @skin_file.path.should eq(MokioSkins::Tests::SKIN_FILE_PATH)
    end
  end
end
