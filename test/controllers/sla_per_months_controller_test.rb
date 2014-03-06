require 'test_helper'

class SlaPerMonthsControllerTest < ActionController::TestCase
  setup do
    @sla_per_month = sla_per_months(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sla_per_months)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sla_per_month" do
    assert_difference('SlaPerMonth.count') do
      post :create, sla_per_month: { customer_id: @sla_per_month.customer_id, month: @sla_per_month.month, year: @sla_per_month.year }
    end

    assert_redirected_to sla_per_month_path(assigns(:sla_per_month))
  end

  test "should show sla_per_month" do
    get :show, id: @sla_per_month
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sla_per_month
    assert_response :success
  end

  test "should update sla_per_month" do
    patch :update, id: @sla_per_month, sla_per_month: { customer_id: @sla_per_month.customer_id, month: @sla_per_month.month, year: @sla_per_month.year }
    assert_redirected_to sla_per_month_path(assigns(:sla_per_month))
  end

  test "should destroy sla_per_month" do
    assert_difference('SlaPerMonth.count', -1) do
      delete :destroy, id: @sla_per_month
    end

    assert_redirected_to sla_per_months_path
  end
end
