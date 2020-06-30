class TagSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :tasks, serializer: TaskSerializer
end
