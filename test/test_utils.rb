require 'test/unit'
require 'programr/utils'

class TestFacade < Test::Unit::TestCase
  def setup
    @robot = ProgramR::Facade.new
    @robot.learn('test/data/facade.aiml')
  end

  def test_aiml_file_finder
    actual = ProgramR::AimlFinder::find(['test/data/mixed/single.aiml', 
                                        'test/data/mixed/dir']).sort
    expected = ['test/data/mixed/single.aiml',
                'test/data/mixed/dir/in_dir.aiml',
                'test/data/mixed/dir/subdir/in_sub_dir.aiml'].sort
    assert_equal(expected, actual)
  end
end
