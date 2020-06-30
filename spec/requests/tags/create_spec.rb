require 'rails_helper'

RSpec.describe 'Create Tag', type: :request do

  context 'when valid title is provided' do
    let(:title) { 'Someday' }

    it 'creates tag' do
      expect { post '/api/v1/tags', params: {title: title} }
        .to change(Tag, :count).by(1)

      expect(response.status).to eq(201)

      expect(response.body).to be_json_eql(%({"title": "Someday"})).at_path('data/attributes')

      expect(response.body).to have_json_path('data/id')
      expect(response.body).to have_json_path('data/type')
      expect(response.body).to have_json_path('data/relationships/tasks')
    end
  end

  context 'when invalid title is provided' do
    let(:title) { '' }

    it 'it does not create tag' do
      expect { post '/api/v1/tags', params: {title: title} }
        .not_to change(Tag, :count)

      expect(response.status).to eq(422)

      expect(response.body).to be_json_eql(%({"errors": ["Title can't be blank"]}))
    end
  end
end
