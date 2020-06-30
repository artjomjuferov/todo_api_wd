require 'rails_helper'

RSpec.describe 'Todos Index', type: :request do

  context 'when tasks are not paginatiing' do
    let!(:task) { create(:task, title: 'Wash laundry') }

    it 'shows all tasks' do
      get '/api/v1/tasks'

      expect(response.status).to eq(200)

      expect(response.body).to be_json_eql(%({"title": "Wash laundry"})).at_path('data/0/attributes')

      expect(response.body).to have_json_path('data/0/id/')
      expect(response.body).to have_json_path('data/0/relationships/tags/data')
    end
  end
end
