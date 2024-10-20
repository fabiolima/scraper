# frozen_string_literal: true

require 'nokogiri'
require "httparty"

class Hering::ProductPageExtractor
  @@rules = {
    name: {
      selector: "h1.hering-hering-components-3-x-product-page--name",
      transform: -> (elements) { elements.first.text }
    },
    price: {
      selector: "span.hering-hering-components-3-x-product-page--price",
      transform: -> (elements) { elements.first.text }
    },
    description: {
      selector: ".hering-hering-components-3-x-product-page--description",
      transform: -> (elements) { elements.first.text }
    },
    images: {
      selector: "ul.hering-hering-components-3-x-product-page--image-list li img",
      transform: -> (elements) { elements.map { |el| el.attribute('src').value } }
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
