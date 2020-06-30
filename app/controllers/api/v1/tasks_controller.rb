class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: %i[update]

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

  def update
    @task.update(title: params[:title])
    
    if @task.valid?
      render json: @task, serializer: TaskSerializer, status: :ok
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {errors: [e.message]}, status: :not_found
  end

  def per_page
    params.dig(:page, :size) || INDEX_PER_PAGE
  end
end
