# frozen_string_literal: true

Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'

  post '/files/upload', to: 'files#upload'

  # Namespace-scoped file storage (the FILE data type). Uploads are terminated by
  # the gateway ("Proxy") and forwarded here. Actions PUT/GET the bytes through the
  # gateway with short-lived signed URLs (see StorageObjects::SignedUrl).
  post '/storage_objects/upload', to: 'storage_objects#upload'
  put '/storage_objects/upload', to: 'storage_objects#upload_signed'
  get '/storage_objects/download', to: 'storage_objects#download', as: :storage_object_download
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /health/liveness that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get '/health/liveness' => 'rails/health#show', as: :rails_health_check

  mount GoodJob::Engine => 'good_job'
  mount ActionCable.server => '/cable'
end
