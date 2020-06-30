require 'rails_helper'

RSpec.describe 'Tags Index', type: :request do

  context 'when tags are not paginatiing' do
    let!(:tag) { create(:tag, title: 'Home') }

    it 'shows all tags' do
      get '/api/v1/tags'

      expect(response.status).to eq(200)

      expect(response.body).to be_json_eql(%({"title": "Home"})).at_path('data/0/attributes')

      expect(response.body).to have_json_path('data/0/id')
      expect(response.body).to have_json_path('data/0/relationships/tasks/data')
    end
  end

  context 'with pagination' do
    let!(:urgent) { create(:tag, title: 'Urgent', created_at: 2.day.ago) }
    let!(:home) { create(:tag, title: 'Home', created_at: 1.day.ago) }

    context 'when 10(default value) tasks per page' do
      it 'shows both tags ordered by created_at' do
        get '/api/v1/tags'

        expect(response.status).to eq(200)

        expect(response.body).to have_json_size(2).at_path('data')

        expect(response.body).to be_json_eql(%({"title": "Home"})).at_path('data/0/attributes')
        expect(response.body).to be_json_eql(%({"title": "Urgent"})).at_path('data/1/attributes')
      end
    end

    context 'when 1 tag per page' do
      before do
        stub_const('Api::V1::TagsController::INDEX_PER_PAGE', 1)
      end

      it 'shows right tag on each page' do
        get '/api/v1/tags'

        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql(%({"title": "Home"})).at_path('data/0/attributes')

        get '/api/v1/tags',  params: { page: 2 }

        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql(%({"title": "Urgent"})).at_path('data/0/attributes')
      end
    end
  end
end
