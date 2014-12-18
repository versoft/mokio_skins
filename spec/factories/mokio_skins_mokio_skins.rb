# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :skin, :class => 'Mokio::Skin' do
    name MokioSkins::Tests::SKIN_NAME

    after(:create) do |skin, evaluator|
    	create_list(:skin_file, 5, :skin_id => skin.id)
    end
  end
end
