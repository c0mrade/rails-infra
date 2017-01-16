class ApplicationController < ActionController::API
  def index
    Rails.cache.fetch('some_data', expires_in: 2.seconds) do
      'some data inside'
    end
    render text: "Request landed at instance: #{APP_INSTANCE_NUMBER}"
  end
end
