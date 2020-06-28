class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :tags_tasks
  has_many :tags, through: :tags_tasks
end
