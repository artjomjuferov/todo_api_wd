require 'rails_helper'

RSpec.describe Tasks::Update do

  subject { described_class.new(task, new_title, tag_titles) }

  let!(:task) { create(:task, title: 'Do Homework') }
  let(:new_title) { 'Laundry' }
  let(:tag_titles) { %w[Home Urgent] }

  context 'when task empty title is provided' do
    let(:new_title) { '' }

    it 'does not update titles' do
      expect { subject.call }.not_to change { task.reload.title }
      expect(Tag.count).to eq(0)
      expect(subject).not_to be_valid
      expect(subject.errors).to eq(["Title can't be blank"])
    end
  end

  context 'when there are too much tags provided' do
    it 'does not update titles' do
      stub_const('Tasks::Update::MAX_TAGS', 1)

      expect { subject.call }.not_to change { task.reload.title }
      expect(Tag.count).to eq(0)

      expect(subject).not_to be_valid
      expect(subject.errors).to eq(['More than 1 tags are provided'])
    end
  end

  context 'when provided proper tags and proper title' do
    let!(:home_tag) { create(:tag, title: 'Home', tasks: [task]) }

    it 'updates title and adds new tags' do
      expect { subject.call }
        .to change { task.reload.title }.to(new_title)
        .and change { task.reload.tags.map(&:title).sort }.to(%w[Home Urgent])
        .and change(Tag, :count).by(1)

      expect(subject).to be_valid
    end
  end

  context 'when update removed tags' do
    let!(:removed_tag) { create(:tag, title: 'Removed', tasks: [task])}

    it 'removes tag' do
      expect { subject.call }
        .to change { task.reload.tags.map(&:title).sort }.from(['Removed']).to(%w[Home Urgent])
        .and change(Tag, :count).by(2)

      expect(subject).to be_valid
    end
  end

  context 'when update removed tags' do
    let!(:removed_tag) { create(:tag, title: 'Removed', tasks: [task]) }
    let!(:home_tag) { create(:tag, title: 'Home') }

    it 'removes tag' do
      expect { subject.call }
        .to change { task.reload.tags.map(&:title).sort }.from(['Removed']).to(%w[Home Urgent])
        .and change(Tag, :count).by(1)

      expect(subject).to be_valid
    end
  end
end
