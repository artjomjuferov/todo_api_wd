class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :tags_tasks
  has_many :tasks, through: :tags_tasks
end
