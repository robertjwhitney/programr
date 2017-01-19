require 'test/unit'
require_relative '../lib/programr/environment'

class TestEnvironment < Test::Unit::TestCase
  def setup
    @env = ProgramR::Environment.new
  end

  def test_readonly_tags_file
    ProgramR::Environment.readonly_tags_file = 'test/data/readOnlyTags.yaml'
    assert_equal(@env.get('bot_name'), 'test bot name')
  end
end
