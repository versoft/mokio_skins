Mokio::Engine.routes.draw do
	resources :skins do
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
    get ':menu_id' => "content#show"
    get ':menu_id/:id' => "content#single"
    root to: "content#home"
  end
end
