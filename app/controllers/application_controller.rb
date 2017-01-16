class ApplicationController < ActionController::API
  def index
    Rails.cache.fetch('some_data', expires_in: 5.seconds) do
      'some data inside'
    end
    render text: 'Request landed at app instance'
  end
end
