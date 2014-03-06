class DowntimesController < ApplicationController
  before_action :set_downtime, only: [:show, :edit, :update, :destroy]

  # GET /downtimes
  # GET /downtimes.json
  def index
    @downtimes = Downtime.all
  end

  # GET /downtimes/1
  # GET /downtimes/1.json
  def show
  end

  # GET /downtimes/new
  def new
    @downtime = Downtime.new
  end

  # GET /downtimes/1/edit
  def edit
  end

  # POST /downtimes
  # POST /downtimes.json
  def create
    @downtime = Downtime.new(downtime_params)

    respond_to do |format|
      if @downtime.save
        format.html { redirect_to @downtime, notice: 'Downtime was successfully created.' }
        format.json { render action: 'show', status: :created, location: @downtime }
      else
        format.html { render action: 'new' }
        format.json { render json: @downtime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /downtimes/1
  # PATCH/PUT /downtimes/1.json
  def update
    respond_to do |format|
      if @downtime.update(downtime_params)
        format.html { redirect_to @downtime, notice: 'Downtime was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @downtime.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /downtimes/1
  # DELETE /downtimes/1.json
  def destroy
    @downtime.destroy
    respond_to do |format|
      format.html { redirect_to downtimes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_downtime
      @downtime = Downtime.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def downtime_params
      params.require(:downtime).permit(:start, :downtimeType, :end, :comment, :SLAPerMonth_id)
    end
end
