require 'rails_helper'

RSpec.describe 'Create Task', type: :request do

  context 'when valid title is provided' do
    let(:title) { 'Do Homework' }

    it 'creates task' do
      expect { post '/api/v1/tasks', params: {title: title} }
        .to change(Task, :count).by(1)

      expect(response.status).to eq(201)

      expect(response.body).to be_json_eql(%({"title": "Do Homework"})).at_path('data/attributes')

      expect(response.body).to have_json_path('data/id')
      expect(response.body).to have_json_path('data/type')
      expect(response.body).to have_json_path('data/relationships/tags')
    end
  end

  context 'when invalid title is provided' do
    let(:title) { '' }

    it 'it does not create task' do
      expect { post '/api/v1/tasks', params: {title: title} }
        .not_to change(Task, :count)

      expect(response.status).to eq(422)

      expect(response.body).to be_json_eql(%({"errors": ["Title can't be blank"]}))
    end
  end
end
