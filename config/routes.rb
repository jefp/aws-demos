Rails.application.routes.draw do
  get 'welcome/index'
  get "burnCPU", to: "welcome#burn"
  root 'welcome#index'
end
