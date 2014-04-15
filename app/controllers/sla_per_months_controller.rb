class SlaPerMonthsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sla_per_month, only: [:show, :edit, :update, :destroy]

  # GET /sla_per_months
  # GET /sla_per_months.json
  def index
    @slapm_active = 'active'
    @sla_per_months = SlaPerMonth.all
  end

  # GET /sla_per_months/1
  # GET /sla_per_months/1.json
  def show
    sla_calculator = UnplannedDowntimeCalculator.new(@sla_per_month.customer)
    @downtime_info = sla_calculator.populate_monthly_sla_for(@sla_per_month)
    @critical_downtimes = sla_calculator.get_all_critical_downtimes_for(@sla_per_month)
  end

  # GET /sla_per_months/new
  def new
    @sla_per_month = SlaPerMonth.new
  end

  # GET /sla_per_months/1/edit
  def edit
  end

  # POST /sla_per_months
  # POST /sla_per_months.json
  def create
    @sla_per_month = SlaPerMonth.new(sla_per_month_params)

    respond_to do |format|
      if @sla_per_month.save
        format.html { redirect_to @sla_per_month, notice: 'Sla per month was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sla_per_month }
      else
        format.html { render action: 'new' }
        format.json { render json: @sla_per_month.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sla_per_months/1
  # PATCH/PUT /sla_per_months/1.json
  def update
    respond_to do |format|
      if @sla_per_month.update(sla_per_month_params)
        format.html { redirect_to @sla_per_month, notice: 'Sla per month was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sla_per_month.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sla_per_months/1
  # DELETE /sla_per_months/1.json
  def destroy
    @sla_per_month.destroy
    respond_to do |format|
      format.html { redirect_to sla_per_months_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sla_per_month
      @slapm_active = 'active'
      @sla_per_month = SlaPerMonth.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sla_per_month_params
      params.require(:sla_per_month).permit(:month, :year, :customer_id)
    end
end
