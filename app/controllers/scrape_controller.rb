class ScrapeController < ApplicationController

  def create
    ExtractDataJob.perform_later task_params
    head :ok
  end

  private 

  def task_params
    params.permit(:id, :url, :webhook)
  end
end
