Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  namespace :api, defaults: { format: :json } do

		namespace :v1 do
			resources :students, only: [:create, :update] do
				put :update_lesson_progress, on: :member
				get :get_lesson_progress, on: :member
			end
		end

  end

end
