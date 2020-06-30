require 'rails_helper'

RSpec.describe TagSerializer, type: :serializer do
  subject { TagSerializer.new(tag).to_json }

  let(:task) { build_stubbed(:task, title: 'Bar') }
  let(:tag) { build_stubbed(:tag, title: 'Foo', tasks: [task]) }

  specify do
    names = %({"title":"Foo", "tasks":[{"title":"Bar"}]})
    is_expected.to be_json_eql(names)

    is_expected.to have_json_path('id')
    is_expected.to have_json_type(Integer).at_path('id')

    is_expected.to have_json_size(1).at_path('tasks')
  end
end
