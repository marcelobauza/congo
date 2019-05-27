class Admin::ImportProcessesController < ApplicationController
  before_action :set_import_process, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  # GET /import_processes
  # GET /import_processes.json
  def index
    @import_processes = ImportProcess.all
  end

  # GET /import_processes/1
  # GET /import_processes/1.json
  def show
  end

  # GET /import_processes/new
  def new
    @import_process = ImportProcess.new
  end

  # GET /import_processes/1/edit
  def edit
  end

  # POST /import_processes
  # POST /import_processes.json
  def create

   tmp_path = Util.make_temp_dir

      temp_file = File.new(tmp_path + "/uploaded_file_to_import_data_source_", "w")
      temp_file.write(params[:import_process][:file].read.force_encoding("UTF-8")) 
      temp_file.close

      params[:import_process][:original_filename] = params[:import_process][:file].original_filename
      params[:import_process][:file_path] = temp_file.path
      params[:import_process][:status] = 'idle'
    @import_process = ImportProcess.new(import_process_params)
    respond_to do |format|
      if @import_process.save
        format.html { redirect_to admin_import_processes_path, notice: 'Import process was successfully created.' }
        format.json { render :show, status: :created, location: @import_process }
      else
        format.html { render :new }
        format.json { render json: @import_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /import_processes/1
  # PATCH/PUT /import_processes/1.json
  def update
    respond_to do |format|
      if @import_process.update(import_process_params)
        format.html { redirect_to @import_process, notice: 'Import process was successfully updated.' }
        format.json { render :show, status: :ok, location: @import_process }
      else
        format.html { render :edit }
        format.json { render json: @import_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /import_processes/1
  # DELETE /import_processes/1.json
  def destroy
    @import_process.destroy
    respond_to do |format|
      format.html { redirect_to import_processes_url, notice: 'Import process was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_import_process
    @import_process = ImportProcess.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def import_process_params
    params.require(:import_process).permit(:file, :status, :file_path, :processed, :inserted, :updated, :failed, :data_source, :original_filename).merge(user_id: current_user.id)
  end
end
