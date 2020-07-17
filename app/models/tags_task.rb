class TagsTask < ApplicationRecord
  belongs_to :tag
  belongs_to :task

  validates_uniqueness_of :tag_id, scope: :task_id
end
