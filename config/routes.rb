Mokio::Engine.routes.draw do
  resources :skins do
     member do
       post :update_active
       get :older_versions
     end
  end
  
  resources :static_modules do
     member do
       post :update_active
     end
  end

  resources :skin_files do
    member do
      put :change_name
    end

    collection do
      patch :add_image
    end
  end
end

Rails.application.routes.draw do
  scope :module => "frontend", :constraints => FrontendConstraint do
    root to: "content#home"
    namespace :contacts do
      get :mail
    end
    get ':menu_id' => "content#show"
    get ':menu_id/:id' => "content#single"
  end
end
