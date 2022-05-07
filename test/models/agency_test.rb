require 'test_helper'

class AgencyTest < ActiveSupport::TestCase
  setup do
    @agency = agencies :nova
  end

  test 'Create agency' do
    @agency = Agency.create(name: 'Inmo')

    assert @agency.valid?
  end

  test 'blank attributes' do
    @agency.name = ''

    assert @agency.invalid?
    assert_error @agency, :name, :blank
  end
end
