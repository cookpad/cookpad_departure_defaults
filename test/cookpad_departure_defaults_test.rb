require "test_helper"

class CookpadDepartureDefaultsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CookpadDepartureDefaults::VERSION
  end

  def test_args_are_sane
    args = CookpadDepartureDefaults.global_percona_args
    assert_match(/alter-foreign-keys-method rebuild_constraints/, args)
    assert_match(/plugin.*pt-online-schema-change-plugin\.pl/, args)
    assert_match(/max-load Threads_running=\d+/, args)

    /max-load Threads_running=(\d+)/ =~ args

    assert($1.to_i > 25) # 25 is the default, and is just too low for our database
  end
end
