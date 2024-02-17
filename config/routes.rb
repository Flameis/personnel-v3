Rails.application.routes.draw do
  root "home#landing"

  ActiveAdmin.routes(self)
  get "/admin/*path", to: redirect("/manage/%{path}") # Support old /admin links

  get "/signout", to: "sessions#destroy", as: :destroy_user_session
  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post], as: :create_user_session
  get "/auth/failure", to: "sessions#failure"

  get "/about" => "home#about"
  get "/about/awards" => "home#awards"
  get "/about/realism" => "home#realism"
  get "/about/ranks" => "home#ranks"
  get "/about/historical" => "home#historical"
  get "/about/server" => "home#server_rules"
  get "/about/faq" => "home#faq"
  get "/about/record" => "home#record"
  get "/about/ourhistory" => "home#our_history"
  get "/contact" => "home#contact"
  get "/donate" => "home#donate"
  get "/servers" => "home#servers"
  get "/enlist" => "home#enlist"

  get "/roster" => "roster#index"

  scope "/api/webhooks" do
    post "/discourse",
      to: "discourse_webhooks#user_activated",
      as: :discourse_webhook_user_activated,
      constraints: ->(request) { request.headers["X-Discourse-Event"] == "user_activated" }

    post "/discourse",
      to: "discourse_webhooks#user_updated",
      as: :discourse_webhook_user_updated,
      constraints: ->(request) { request.headers["X-Discourse-Event"] == "user_updated" }

    # return 204 for all other events
    post "/discourse",
      to: ->(env) { [204, {}, [""]] },
      as: :discourse_webhooks_unrecognised
  end

  resources :members, controller: :users, as: :users, only: [:show] do
    get "service-record", to: "users#service_record"
    get "attendance", to: "users#attendance"
    get "qualifications", to: "users#qualifications"
    get "recruits", to: "users#recruits"
    get "reprimands", to: "users#reprimands"
    get "extended-loas", to: "users#extended_loas"
  end

  resources :passes, only: [:index, :show]
  resources :events, only: [:index, :show] do
    member do
      get "aar", to: "events#edit_aar"
      patch "aar", to: "events#update_aar"
      put "loa", to: "events#loa"
    end
  end

  resources :enlistments, only: [:show, :new, :create]
end
