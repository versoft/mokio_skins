# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :skin_file, :class => 'Mokio::SkinFile' do
    name MokioSkins::Tests::SKIN_FILE_NAME
    path MokioSkins::Tests::SKIN_FILE_PATH
  end
end
