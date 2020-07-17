# Service object which updates title of the task and adds provided tags.
# If provided tag does not exist it will create it.
#
# Service is supposed to be:
#   1. initialized
#   2. called with `call` method
#   3. and checked if it's valid?
class Tasks::Update
  MAX_TAGS = 100

  attr_reader :task, :errors

  def initialize(task, new_title, tag_titles)
    @task = task
    @new_title = new_title
    @tag_titles = Array(tag_titles).compact.uniq
    @errors = []
  end

  def call
    check_amount_of_tags
    update if valid?
  end

  def valid?
    @errors.empty?
  end

  private

  def update
    return if @task.update(title: @new_title, tags: existing_tags + new_tags)
    @errors = @task.errors.full_messages unless @task.valid?
  end

  def check_amount_of_tags
    return if @tag_titles.size <= MAX_TAGS
    @errors = ["More than #{MAX_TAGS} tags are provided"]
  end

  def existing_tags
    @existing_tags ||= Tag.where(title: @tag_titles)
  end

  def new_tags
    tag_titles_for_adding.map { |title| Tag.new(title: title) }
  end

  def tag_titles_for_adding
    @tag_titles - existing_tags.map(&:title)
  end
end
