require 'rails_helper'

RSpec.describe 'Update Task', type: :request do
  let!(:task) { create(:task, title: 'Do Homework') }

  let(:new_title) { 'Updated Task Title' }

  context 'when task is not found' do
    it 'returns error' do
      expect { patch '/api/v1/tasks/-1', params: {title: new_title} }
        .not_to change { task.reload.title }

      expect(response.status).to eq(404)

      expect(response.body).to be_json_eql(%({"errors": ["Couldn't find Task with 'id'=-1"]}))
    end
  end

  context 'when valid title is provided' do
    it 'returns error' do
      expect { patch "/api/v1/tasks/#{task.id}", params: {title: new_title} }
        .to change{ task.reload.title }.from('Do Homework').to(new_title)

      expect(response.status).to eq(200)

      expect(response.body).to be_json_eql(%({"title": "Updated Task Title"})).at_path('data/attributes')

      expect(response.body).to have_json_path('data/id')
      expect(response.body).to have_json_path('data/type')
      expect(response.body).to have_json_path('data/relationships/tags')
    end
  end

  context 'when valid title and proper tag are provided' do
  end
end
