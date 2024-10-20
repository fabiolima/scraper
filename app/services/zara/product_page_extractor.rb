# frozen_string_literal: true

require 'nokogiri'
require "httparty"

class Zara::ProductPageExtractor
  @@rules = {
    name: {
      selector: "h1",
      transform: -> (elements) { elements.last.text }
    },
    price: {
      selector: ".money-amount__main",
      transform: -> (elements) { elements.last.text }
    },
    description: {
      selector: ".product-detail-description",
      transform: -> (elements) { elements.last.text }
    },
    images: {
      selector: ".product-detail-images picture.media-image source:first-child",
      transform: -> (elements) { 
        elements
          .map { |el| el.attribute('srcset').value }
          .map { |srcset| srcset.split(' ').first }
      }
    }
  }

  def initialize(params)
    @params = params
    @result = {}

    super()
  end

  def extract
    extract_data
    notify
  end

  private

  def notify 
    payload = {
      event: {
        type: "task.status.completed",
        result: @result,
        resource: @params
      }
    }

    headers = {
      'Content-Type' => 'application/json'
    }

    HTTParty.post(@params[:webhook], body: payload.to_json, headers: headers)
  end

  def extract_data
    doc = Nokogiri::HTML.parse(page)

    @@rules.keys.each do |key|
      @result[key] = @@rules[key][:transform].call doc.css(@@rules[key][:selector]) 
    end
  end

  def page
    headers = { "User-Agent" => "Mozilla\/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit\/537.36 (KHTML, like Gecko) Chrome\/128.0.0.0 Safari\/537.36" }
    HTTParty.get(@params[:url], headers: headers)
  end
end
