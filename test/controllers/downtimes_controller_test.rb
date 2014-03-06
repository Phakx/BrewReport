require 'test_helper'

class DowntimesControllerTest < ActionController::TestCase
  setup do
    @downtime = downtimes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:downtimes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create downtime" do
    assert_difference('Downtime.count') do
      post :create, downtime: { SLAPerMonth_id: @downtime.SLAPerMonth_id, comment: @downtime.comment, downtimeType: @downtime.downtimeType, end: @downtime.end, start: @downtime.start }
    end

    assert_redirected_to downtime_path(assigns(:downtime))
  end

  test "should show downtime" do
    get :show, id: @downtime
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @downtime
    assert_response :success
  end

  test "should update downtime" do
    patch :update, id: @downtime, downtime: { SLAPerMonth_id: @downtime.SLAPerMonth_id, comment: @downtime.comment, downtimeType: @downtime.downtimeType, end: @downtime.end, start: @downtime.start }
    assert_redirected_to downtime_path(assigns(:downtime))
  end

  test "should destroy downtime" do
    assert_difference('Downtime.count', -1) do
      delete :destroy, id: @downtime
    end

    assert_redirected_to downtimes_path
  end
end
