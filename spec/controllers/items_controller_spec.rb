require 'rails_helper'

RSpec.describe ItemsController, :type => :controller do
  let(:project) { Project.create!(title: 'A Project') }

  describe 'GET new' do
    before do
      get :new, params: { project_id: project.id }
    end

    it 'renders the new action successfully' do
      expect(response).to have_http_status :success
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      before do
        post :create, params: { project_id: project.id,
                        item: { action: 'Retrieve money.' } }
      end

      it 'creates a new item' do
        expect(project.reload.items.count).to eq 1
      end

      it 'sets notice' do
        expect(flash[:notice]).to eq('Item was successfully created.')
      end

      it 'redirects to project page' do
        expect(response).to redirect_to project_path(project)
      end
    end
  end

  describe 'GET edit' do
    let(:item) { project.items.create(action: 'Go shopping.') }
    before do
      get :edit, params: { project_id: project.id, id: item.id }
    end

    it 'renders the edit action successfully' do
      expect(response).to have_http_status :success
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:item) {
        project = Project.create!(title: 'A Project')
        project.items.create!(action: 'thing to do')
      }
      before do
        put :update, params: { id: item.id, project_id: item.project.id,
                       item: { action: 'bar' } }
      end

      it 'updates the requested item' do
        expect(Item.first.action).to eq 'bar'
      end

      it 'redirects to the project page' do
        expect(response).to redirect_to project_path(item.project)
      end
    end
  end
end
