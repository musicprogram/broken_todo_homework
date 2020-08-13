require 'rails_helper'

RSpec.describe Item, :type => :model do
  let(:params) {
    {
      action: 'Do something',
      project: Project.create(title: 'New Project')
    }
  }

  subject { Item.new(params) }

  describe 'validations' do
    it 'is valid with valid params' do
      expect(subject).to be_valid
    end

    it 'requires an action' do
      params[:action] = ''

      expect(subject).not_to be_valid
    end

    it 'requires action be unique within a project' do
      subject.save

      duplicate_action = Item.new(params)

      expect(duplicate_action).not_to be_valid
      expect(duplicate_action.errors.keys).to include :action
    end
  end
end
