class ApplicationController < ActionController::API

  private

  def title_param
    params.dig(:data, :attributes, :title)
  end
end
