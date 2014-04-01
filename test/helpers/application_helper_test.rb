require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'application helper' do
    ApplicationHelper.import_downtimes_from_icinga(1,2,3, 4)
  end
end
