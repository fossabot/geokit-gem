require 'test/unit'
require 'lib/geokit'

class GeoLocTest < Test::Unit::TestCase #:nodoc: all
  
  def setup
    @loc = Geokit::GeoLoc.new
  end
  
  def test_initialize_with_hash
    street_address = '123 Address St.'
    city = 'Palo Alto'
    suggested_bounds = [[35,-122],[34,-121]]
    loc_hash = {:street_address => street_address, :city => city, 'suggested_bounds' => suggested_bounds}
    loc = Geokit::GeoLoc.new(loc_hash)
    assert_equal street_address, loc.street_address
    assert_equal city, loc.city
    assert_equal suggested_bounds[0][0], loc.suggested_bounds.sw.lat
    assert_equal suggested_bounds[0][1], loc.suggested_bounds.sw.lng
    assert_equal suggested_bounds[1][0], loc.suggested_bounds.ne.lat
    assert_equal suggested_bounds[1][1], loc.suggested_bounds.ne.lng
  end
    
  
  def test_is_us
    assert !@loc.is_us?
    @loc.country_code = 'US'
    assert @loc.is_us?
  end
  
  def test_success
    assert !@loc.success?
    @loc.success = false
    assert !@loc.success?
    @loc.success = true
    assert @loc.success?
  end
  
  def test_street_number
    @loc.street_address = '123 Spear St.'
    assert_equal '123', @loc.street_number
  end
  
  def test_street_name
    @loc.street_address = '123 Spear St.'
    assert_equal 'Spear St.', @loc.street_name
  end
  
  def test_city
    @loc.city = "san francisco"
    assert_equal 'San Francisco', @loc.city
  end
  
  def test_full_address
    @loc.city = 'San Francisco'
    @loc.state = 'CA'
    @loc.zip = '94105'
    @loc.country_code = 'US'
    assert_equal 'San Francisco, CA, 94105, US', @loc.full_address
    @loc.full_address = 'Irving, TX, 75063, US'
    assert_equal 'Irving, TX, 75063, US', @loc.full_address
  end
  
  def test_hash
    @loc.city = 'San Francisco'
    @loc.state = 'CA'
    @loc.zip = '94105'
    @loc.country_code = 'US'
    @another = Geokit::GeoLoc.new @loc.to_hash    
    assert_equal @loc, @another
  end
  
  def test_all
    assert_equal [@loc], @loc.all
  end
  
  def test_to_yaml
    @loc.city = 'San Francisco'
    @loc.state = 'CA'
    @loc.zip = '94105'
    @loc.country_code = 'US'
    assert_equal( 
      "--- !ruby/object:Geokit::GeoLoc \naccuracy: \ncity: San Francisco\ncountry: \ncountry_code: US\ndistrict: \nfull_address: \nlat: \nlng: \nprecision: unknown\nprovince: \nstate: CA\nstreet_address: \nsuccess: false\nzip: \"94105\"\n",
      @loc.to_yaml)
  end

  def test_as_json
    city = 'Palo Alto'
    state = 'CA'
    zip = '94301'
    country_code = 'US'
    sw_lat = 34.0
    sw_lon = -122.0
    ne_lat = 35.0
    ne_lon = -121.0

    @loc.city = city
    @loc.state = state
    @loc.zip = zip
    @loc.country_code = country_code
    @loc.suggested_bounds = Geokit::Bounds.normalize([[sw_lat, sw_lon], [ne_lat, ne_lon]])
    result = @loc.as_json

    assert_equal city, result[:city]
    assert_equal state, result[:state]
    assert_equal zip, result[:zip]
    assert_equal country_code, result[:country_code]
    assert_equal [[sw_lat, sw_lon], [ne_lat, ne_lon]], result[:suggested_bounds]
  end
  
end