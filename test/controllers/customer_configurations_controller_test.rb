require 'test_helper'

class CustomerConfigurationsControllerTest < ActionController::TestCase
  setup do
    @customer_configuration = customer_configurations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_configurations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_configuration" do
    assert_difference('CustomerConfiguration.count') do
      post :create, customer_configuration: { customer_id: @customer_configuration.customer_id, dailySlaEnd: @customer_configuration.dailySlaEnd, dailySlaStart: @customer_configuration.dailySlaStart, excludedDays: @customer_configuration.excludedDays, weeklySlaDays: @customer_configuration.weeklySlaDays }
    end

    assert_redirected_to customer_configuration_path(assigns(:customer_configuration))
  end

  test "should show customer_configuration" do
    get :show, id: @customer_configuration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_configuration
    assert_response :success
  end

  test "should update customer_configuration" do
    patch :update, id: @customer_configuration, customer_configuration: { customer_id: @customer_configuration.customer_id, dailySlaEnd: @customer_configuration.dailySlaEnd, dailySlaStart: @customer_configuration.dailySlaStart, excludedDays: @customer_configuration.excludedDays, weeklySlaDays: @customer_configuration.weeklySlaDays }
    assert_redirected_to customer_configuration_path(assigns(:customer_configuration))
  end

  test "should destroy customer_configuration" do
    assert_difference('CustomerConfiguration.count', -1) do
      delete :destroy, id: @customer_configuration
    end

    assert_redirected_to customer_configurations_path
  end
end
