class ProjectsController < ApplicationController
  before_action :set_project, except: %i[index new create]

  def index
    #@projects = Project.kept only mo deleted
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html {
                      redirect_to project_path(@project),
                      notice: 'Project was successfully created.'
                    }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    # @@project.discarded_at = nil if params.dig(:restore)
    @project.undiscard if params.dig(:restore)

    respond_to do |format|
      if @project.update(project_params)
        format.html {
                      redirect_to project_path(@project),
                      notice: 'Project was successfully updated.'
                    }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    if @project.discarded?
      @project.destroy
    else
      @project.discard
    end
    respond_to do |format|
      format.html {
                    redirect_to projects_path,
                    notice: 'Project was successfully destroyed.'
                  }
    end
  end

  def clear
    if @project.items.complete.length > 0
      @project.items.complete.each do |item|
        if item.discarded?
          item.delete
        else
          item.discard
        end
      end
      #
      msg = 'Completed items were successfully cleared.'
    else
      msg = 'There are no completed items for this project.'
    end

    respond_to do |format|
      format.html {
        redirect_to project_path(@project),
                    notice: msg
      }
    end

  end

private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title)
  end
end

