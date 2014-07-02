class IcingaImporterController < ApplicationController
  before_action :authenticate_user!
  before_action :prepare_action
  def new
  end

  def create
    Rails.logger.debug 'Import controller Create called'
    @customers_all.each do |customer|
      Rails.logger.debug "#{customer.id}, #{customer_params[:customer_name]}"
      if   customer.id.to_s == customer_params[:customer_name]
        @customer = customer
      end
    end
    icinga_importer = IcingaImporter.new(@customer)
    icinga_importer.import_downtimes_from_icinga(URI.encode(customer_params[:url]), customer_params[:username], customer_params[:password])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def prepare_action
    @title = 'Icinga Import'
    @impoter_active = 'active'
    @customers_all = Customer.all

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:import_helper).permit(:url, :username, :password, :customer_name)
  end
end
