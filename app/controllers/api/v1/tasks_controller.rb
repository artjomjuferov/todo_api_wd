class Api::V1::TasksController < ApplicationController
  INDEX_PER_PAGE = 10

  def index
    tasks = Task.all
    paginate json: tasks,
             per_page: per_page,
             status: :ok,
             include: 'tags'
  end

  def create
    @task = Task.create(title: params[:title])
    if @task.valid?
      render json: @task, serializer: TaskSerializer, status: :created
    else
      render json: {errors: @task.errors.full_messages}, status: 	:unprocessable_entity
    end
  end

  private

  def per_page
    params.dig(:page, :size) || INDEX_PER_PAGE
  end
end
