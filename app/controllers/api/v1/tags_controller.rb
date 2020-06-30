class Api::V1::TagsController < ApplicationController
  before_action :set_tag, only: %i[update]

    INDEX_PER_PAGE = 10

    def index
      tags = Tag.order(created_at: :desc)
      paginate json: tags,
               per_page: INDEX_PER_PAGE,
               status: :ok,
               include: 'tasks'
    end

  def create
    tag = Tag.create(title: params[:title])

    if tag.valid?
      render json: tag, serializer: TagSerializer, status: :created
    else
      render json: {errors: tag.errors.full_messages}, status: 	:unprocessable_entity
    end
  end

  def update
    @tag.update(title: params[:title])

    if @tag.valid?
      render json: @tag, serializer: TagSerializer, status: :ok
    else
      render json: {errors: @tag.errors.full_messages}, status: 	:unprocessable_entity
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {errors: [e.message]}, status: :not_found
  end
end
