class ExtractDataJob < ApplicationJob
  queue_as :default

  def perform(task_params)
    uri = URI(task_params[:url])

    case uri.host
    when /zara/ then Zara::ProductPageExtractor.new(task_params).extract
    when /hering/ then Hering::ProductPageExtractor.new(task_params).extract
    else
      ErrorResponse::UnsupportedHost.new(task_params).respond
    end
  end
end
