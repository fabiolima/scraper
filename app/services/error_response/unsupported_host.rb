# frozen_string_literal: true

require "httparty"

class ErrorResponse::UnsupportedHost

  def initialize(params)
    @params = params
    super()
  end

  def respond
    notify
  end

  private

  def notify 
    uri = URI(@params[:url])

    payload = {
      event: {
        type: "task.status.error",
        error_message: "Scraper don't know how to handle #{uri.host}. Supported hosts are: www.zara.com, www.hering.com.",
        resource: @params
      }
    }

    headers = {
      'Content-Type' => 'application/json'
    }

    HTTParty.post(@params[:webhook], body: payload.to_json, headers: headers)
  end
end
