require 'rails_helper'

RSpec.describe 'Todos Index', :type => :request do

  context 'when tasks are not paginatiing' do
    let!(:task) { create(:task) }

    it 'shows all tasks' do
      get '/api/v1/tasks'

      expect(response.body).to have_json_path('data/0/id/')

      expect(response.body).to have_json_path('data/0/attributes/title')
      expect(response.body).to have_json_path('data/0/relationships/tags/data')
    end
  end
end
