require 'rails_helper'

RSpec.describe TagsTask, type: :model do
  describe 'uniq validation' do
    let!(:tag) { create(:tag, title: 'Home') }
    let!(:task) { create(:task, title: 'Make bed') }

    context 'when it is uniq' do
      it 'raises no errors' do
        expect { tag.tasks << task }.not_to raise_error
      end
    end

    context 'when it is duplicated' do
      it 'raises the error' do
        tag.tasks << task
        expect { tag.tasks << task }.to raise_error(ActiveRecord::RecordInvalid)
      end

      context 'when validation is skipped' do
        it 'raises db error' do
          tag.tasks << task
          expect { TagsTask.new(task: task, tag: tag).save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
        end
      end
    end
  end
end
