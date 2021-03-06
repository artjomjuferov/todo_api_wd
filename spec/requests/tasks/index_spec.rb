require 'rails_helper'

RSpec.describe 'Todos Index', type: :request do

  context 'when tasks are not paginatiing' do
    let!(:task) { create(:task, title: 'Wash laundry') }

    it 'shows all tasks' do
      get '/api/v1/tasks'

      expect(response.status).to eq(200)

      expect(response.body).to be_json_eql(%({"title": "Wash laundry"})).at_path('data/0/attributes')

      expect(response.body).to have_json_path('data/0/id')
      expect(response.body).to have_json_path('data/0/relationships/tags/data')
    end
  end

  context 'with pagination' do
    let!(:task_laundry) { create(:task, title: 'Wash Laundry', created_at: 2.day.ago) }
    let!(:task_homework) { create(:task, title: 'Do Homework', created_at: 1.day.ago) }

    context 'when 10(default value) tasks per page' do
      it 'shows both tasks ordered by created_at' do
        get '/api/v1/tasks'

        expect(response.status).to eq(200)

        expect(response.body).to have_json_size(2).at_path('data')

        expect(response.body).to be_json_eql(%({"title": "Do Homework"})).at_path('data/0/attributes')
        expect(response.body).to be_json_eql(%({"title": "Wash Laundry"})).at_path('data/1/attributes')
      end
    end

    context 'when 1 task per page' do
      before do
        stub_const('Api::V1::TasksController::INDEX_PER_PAGE', 1)
      end

      it 'shows right task on each page' do
        get '/api/v1/tasks'

        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql(%({"title": "Do Homework"})).at_path('data/0/attributes')

        get '/api/v1/tasks',  params: { page: 2 }

        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql(%({"title": "Wash Laundry"})).at_path('data/0/attributes')
      end
    end
  end

  context 'with applied tags as a filter' do
    let(:urgent_tag) { create(:tag, title: 'Urgent') }
    let(:mom_tag) { create(:tag, title: 'Mom Asked') }

    let!(:task_laundry) { create(:task, title: 'Wash Laundry', tags: [mom_tag]) }
    let!(:task_homework) { create(:task, title: 'Do Homework', tags: [urgent_tag]) }

    let(:params) do
      { data: { attributes: { tags: ['Urgent'] } } }
    end

    it 'shows tags with provided tags only' do
      get '/api/v1/tasks',  params: params

      expect(response.status).to eq(200)
      expect(response.body).to have_json_size(1).at_path('data')
      expect(response.body).to be_json_eql(%({"title": "Do Homework"})).at_path('data/0/attributes')
    end
  end
end
