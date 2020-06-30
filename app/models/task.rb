class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :tags_tasks
  has_many :tags, through: :tags_tasks

  # Returns all tasks with provided tag's titles, OR rule is applied
  def self.with_tags(titles)
    return all if Array(titles).empty?

    joins(:tags).where(tags: { title: titles} ).distinct
  end
end
