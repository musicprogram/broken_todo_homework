require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  let(:valid_attributes) { { 'title' => 'MyString' } }

  describe 'GET index' do
    it 'gets the index correctly' do
      get :index
      expect(response).to have_http_status :success
    end
  end

  describe 'GET show' do
    it 'gets the project details correctly' do
      project = Project.create! valid_attributes
      get :show, params: { id: project.id }
      expect(response).to have_http_status :success
    end
  end

  describe 'GET new' do
    it 'gets the new project path correctly' do
      get :new
      expect(response).to have_http_status :success
    end
  end

  describe 'GET edit' do
    it 'edits the right project' do
      project = Project.create! valid_attributes
      get :edit, params: { id: project.id }
      expect(response).to have_http_status :success
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Project' do
        expect {
          post :create, params: { project: valid_attributes }
        }.to change(Project, :count).by 1
      end

      it 'redirects to the project' do
        post :create, params: { project: valid_attributes }
        expect(response).to redirect_to project_path(Project.first)
      end
    end

    describe 'with invalid params' do
      it 'does not create a new project' do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        expect {
          post :create, params: { project: valid_attributes }
        }.not_to change(Project, :count)
        expect(response).to have_http_status :success
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested project' do
        project = Project.create! valid_attributes
        # Assuming there are no other projects in the database, this
        # specifies that the Project created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Project).to receive(:update).and_call_original

        put :update,
          params: { id: project.to_param, project: { 'title' => 'My String 2' } }
        expect(project.reload.title).to eq 'My String 2'
      end

      it 'redirects to the project' do
        project = Project.create! valid_attributes
        put :update, params: { id: project.to_param, project: { 'title' => 'MyString' } }
        expect(response).to redirect_to project_path(project)
      end
    end

    describe 'with invalid params' do
      it 'does not update the project' do
        project = Project.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        put :update, params: { id: project.to_param,
                       project: { 'title' => 'invalid value' } }
        expect(Project.last.title).to eq 'MyString'
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested project' do
      project = Project.create! valid_attributes
      expect {
        delete :destroy, params: { id: project.id }
      }.to change(Project, :count).by -1
    end

    it 'redirects to the projects list' do
      project = Project.create! valid_attributes
      delete :destroy, params: { id: project.id }
      expect(response).to redirect_to projects_url
    end
  end

  describe 'DELETE clear' do
    let(:project) { Project.create!(title: 'Project') }

    before do
      project.items.create(action: 'test')
    end

    it 'invokes the clear action successfully' do
      delete :clear, params: { id: project.id }
      expect(response).to redirect_to project_url(project)
    end

    it 'does not destroy incomplete items' do
      delete :clear, params: { id: project.id }
      expect(project.items.count).to eq 1
    end

    it 'destroys complete items' do
      project.items.first.update(done: true)
      delete :clear, params: { id: project.id }
      expect(project.reload.items.count).to eq 0
    end
  end
end
