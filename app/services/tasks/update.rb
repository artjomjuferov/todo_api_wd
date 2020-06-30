# Service object which updates title of the task and
# adds provided tags if it does not exist it will create it
class Tasks::Update
  MAX_TAGS = 100

  attr_reader :task, :errors

  def initialize(task, params)
    @task = task
    @params = params
    @tag_titles = Array(@params[:tags]).compact.uniq
    @errors = []
  end

  def call
    check_amount_of_tags
    Task.transaction do
      update_title if valid?
      add_tags if valid?
    end
  end

  def valid?
    @errors.empty?
  end

  private

  def check_amount_of_tags
    return if @tag_titles.size <= MAX_TAGS
    @errors = ["More than #{MAX_TAGS} tags are provided"]
  end

  def update_title
    @task.update(title: @params[:title])
    @errors = @task.errors.full_messages unless @task.valid?
  end

  def add_tags
    tag_titles_for_adding.each { |tag_title| handle_tag(tag_title) }
  end

  def handle_tag(tag_title)
    new_tag = Tag.find_or_create_by(title: tag_title)
    unless new_tag.valid?
      @errors = new_tag.erros.full_messages + ' (Tag)'
      raise ActiveRecord::Rollback
    end
    @task.tags << new_tag
  end

  def tag_titles_for_adding
    @tag_titles - existing_tags.pluck(:title)
  end

  def existing_tags
    Tag
      .where(title: @tag_titles)
      .joins(:tags_tasks)
      .where(tags_tasks: { task_id: @task.id })
  end
end
