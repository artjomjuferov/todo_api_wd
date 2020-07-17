class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404(e)
    render json: {errors: [e.message]}, status: :not_found
  end

  private

  def title_param
    params.dig(:data, :attributes, :title)
  end
end
