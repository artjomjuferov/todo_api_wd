class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :tags

  has_many :tags, serializer: TagSerializer
end
