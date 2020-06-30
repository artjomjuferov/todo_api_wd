require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:tags) }
  end

  describe '.with_tags' do
    subject { described_class.with_tags(titles)}
    let(:tag) { create(:tag, title: 'Urgent') }
    let!(:task) { create(:task, tags: [tag]) }

    context 'when empty provided' do
      let(:titles) { [] }
      it { is_expected.to eq([task]) }
    end

    context 'when actuall title of task is provided' do
      let(:titles) { ['Urgent'] }
      it { is_expected.to eq([task]) }
    end

    context 'when 2 actuall tags are provided' do
      let!(:one_more_tag) { create(:tag, title: 'Home', tasks: [task])}
      let(:titles) { %w[Home Urgent] }
      it { is_expected.to eq([task]) }
    end

    context 'when 2 tasks have one provided tag' do
      let(:second_tag) { create(:tag, title: 'Home')}
      let!(:second_task) { create(:task, title: 'Make bed', tags: [second_tag])}
      let(:titles) { %w[Home Urgent] }
      it { is_expected.to include(task, second_task) }
    end
  end
end
