Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    get 'parse' => 'parser#parse'
  end
end
