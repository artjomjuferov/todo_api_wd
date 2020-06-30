class Api::V1::TagsController < ApplicationController

  def create
    tag = Tag.create(title: params[:title])

    if tag.valid?
      render json: tag, serializer: TagSerializer, status: :created
    else
      render json: {errors: tag.errors.full_messages}, status: 	:unprocessable_entity
    end
  end
end
