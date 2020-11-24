require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  setup do
    latitude  = -70.6477348
    longitude = -33.436942
    @transaction = transactions :santiago
  end

  test 'blank attributes' do
    @transaction.property_type    = nil
    @transaction.address          = ''
    @transaction.sheet            = ''
    @transaction.number           = ''
    @transaction.inscription_date = ''
    @transaction.buyer_name       = ''
    @transaction.seller_type_id   = ''
    @transaction.calculated_value = ''
    @transaction.year             = ''
    @transaction.sample_factor    = ''
    @transaction.county           = nil
    @transaction.role             = ''
    @transaction.seller_name      = ''
    @transaction.buyer_name       = ''
    @transaction.tome             = ''
    @transaction.user             = nil
    @transaction.surveyor         = nil
    @transaction.active           = ''
    @transaction.bimester         = ''
    @transaction.code_sii         = ''
    @transaction.latitude         = ''
    @transaction.longitude        = ''
    @transaction.the_geom         = ''

    assert @transaction.invalid?
    assert_error @transaction, :property_type_id, :blank
    assert_error @transaction, :address, :blank
    assert_error @transaction, :sheet, :blank
    assert_error @transaction, :sheet, :not_a_number
    assert_error @transaction, :number, :blank
    assert_error @transaction, :inscription_date, :blank
    assert_error @transaction, :seller_type_id, :blank
    assert_error @transaction, :calculated_value, :blank
    assert_error @transaction, :year, :blank
    assert_error @transaction, :sample_factor, :blank
    assert_error @transaction, :county_id, :blank
    assert_error @transaction, :role, :blank
    assert_error @transaction, :tome, :blank
    assert_error @transaction, :user_id, :blank
    assert_error @transaction, :surveyor_id, :blank
    assert_error @transaction, :bimester, :blank
    assert_error @transaction, :code_sii, :blank
    assert_error @transaction, :latitude, :blank
    assert_error @transaction, :longitude, :blank
  end
end
