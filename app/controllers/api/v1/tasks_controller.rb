class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: %i[update]

  INDEX_PER_PAGE = 10

  def index
    tasks = Task.with_tags(params[:tags]).order(created_at: :desc)
    paginate json: tasks,
             per_page: INDEX_PER_PAGE,
             status: :ok,
             include: 'tags'
  end

  def create
    task = Task.create(title: params[:title])

    if task.valid?
      render json: task, serializer: TaskSerializer, status: :created
    else
      render json: {errors: task.errors.full_messages}, status: 	:unprocessable_entity
    end
  end

  def update
    task_update = Tasks::Update.new(@task, params)
    task_update.call

    if task_update.valid?
      render json: task_update.task, serializer: TaskSerializer, status: :ok
    else
      render json: {errors: task_update.errors}, status: 	:unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {errors: [e.message]}, status: :not_found
  end
end
