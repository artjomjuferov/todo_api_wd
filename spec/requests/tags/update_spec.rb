require 'rails_helper'

RSpec.describe 'Update Task', type: :request do
  let!(:tag) { create(:tag, title: 'Do Homework') }

  let(:new_title) { 'Updated Task Title' }

  context 'when task is not found' do
    it 'returns error' do
      expect { patch '/api/v1/tags/-1', params: {title: new_title} }
        .not_to change { tag.reload.title }

      expect(response.status).to eq(404)

      expect(response.body).to be_json_eql(%({"errors": ["Couldn't find Tag with 'id'=-1"]}))
    end
  end

  context 'when invalid title is provided' do
    let(:new_title) { '' }

    it 'returns error' do
      expect { patch "/api/v1/tags/#{tag.id}", params: {title: new_title} }
        .not_to change{ tag.reload.title }

      expect(response.status).to eq(422)

      expect(response.body).to be_json_eql(%({"errors": ["Title can't be blank"]}))
    end
  end

  context 'when valid title is provided' do
    it 'updates title' do
      expect { patch "/api/v1/tags/#{tag.id}", params: {title: new_title} }
        .to change{ tag.reload.title }.from('Do Homework').to(new_title)

      expect(response.status).to eq(200)

      expect(response.body).to be_json_eql(%({"title": "Updated Task Title"})).at_path('data/attributes')

      expect(response.body).to have_json_path('data/id')
      expect(response.body).to have_json_path('data/type')
      expect(response.body).to have_json_path('data/relationships/tasks')
    end
  end
end
