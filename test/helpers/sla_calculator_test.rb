require 'test_helper'

class SlaCalculatorTest < ActionView::TestCase
  test 'sla_calc_STUFF DAMMIT' do
    customer = Customer.find_by_name('TestCustomer')
    slaC = SlaCalculator.new(customer)
    monthly_sla_for = slaC.populate_monthly_sla_for('1')
    puts monthly_sla_for
  end
end