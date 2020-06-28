class Api::V1::TasksController < ApplicationController

  INDEX_PER_PAGE = 10

  def index
    tasks = Task.all
    paginate json: tasks,
             per_page: per_page,
             status: :ok,
             include: 'tags'
  end

  private

  def per_page
    params.dig(:page, :size) || INDEX_PER_PAGE
  end
end
