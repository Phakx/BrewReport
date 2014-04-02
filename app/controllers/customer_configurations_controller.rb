class CustomerConfigurationsController < ApplicationController
  before_action :set_customer_configuration, only: [:show, :edit, :update, :destroy]

  # GET /customer_configurations
  # GET /customer_configurations.json
  def index
    @customer_config_active = 'active'
    @customer_configurations = CustomerConfiguration.all
  end

  # GET /customer_configurations/1
  # GET /customer_configurations/1.json
  def show
  end

  # GET /customer_configurations/new
  def new
    @customer_configuration = CustomerConfiguration.new
  end

  # GET /customer_configurations/1/edit
  def edit
  end

  # POST /customer_configurations
  # POST /customer_configurations.json
  def create
    @customer_configuration = CustomerConfiguration.new(customer_configuration_params)

    respond_to do |format|
      if @customer_configuration.save
        format.html { redirect_to @customer_configuration, notice: 'Customer configuration was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer_configuration }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_configurations/1
  # PATCH/PUT /customer_configurations/1.json
  def update
    respond_to do |format|
      if @customer_configuration.update(customer_configuration_params)
        format.html { redirect_to @customer_configuration, notice: 'Customer configuration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_configurations/1
  # DELETE /customer_configurations/1.json
  def destroy
    @customer_configuration.destroy
    respond_to do |format|
      format.html { redirect_to customer_configurations_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_customer_configuration
    @customer_config_active = 'active'
    @customer_configuration = CustomerConfiguration.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_configuration_params
    params.require(:customer_configuration).permit(:customer_id, :dailySlaStart, :dailySlaEnd, :weeklySlaDays, :excludedDays)
  end
end
