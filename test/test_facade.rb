require 'test/unit'
require 'programr/facade'
require 'programr/aiml_elements'
require 'date'

class TestFacade < Test::Unit::TestCase
  def setup
    @robot = ProgramR::Facade.new
    @robot.learn('test/data/facade.aiml')
  end

  def test_stimula_reaction
    assert_equal('test succeded', @robot.get_reaction('atomic test'), 'ATOMIC')
    assert_equal('test succeded', @robot.get_reaction('srai test'), "SRAI")
    assert_equal('new test succeded',@robot.get_reaction('atomic test'),"TOPIC")
    assert_equal('that test 1', @robot.get_reaction('that test'), 'THAT 1')
    assert_equal('that test 2', @robot.get_reaction('that test'), "THAT 2")
    assert_equal('topic star test succeded OK', 
                  @robot.get_reaction('atomic test'), "STAR TOPIC")
    assert_equal('the UPPERCASE test', @robot.get_reaction('uppercase test'))
    assert_equal('the lowercase test', @robot.get_reaction('LOWERCASE TEST'))
    assert_equal(Date.today.to_s, @robot.get_reaction('DATE TEST'))
    assert_equal('time:' + `date`.chomp, @robot.get_reaction('SYSTEM TEST'))
    assert_equal(ProgramR::Category.cardinality.to_s, 
                 @robot.get_reaction('SIZE TEST'))
    assert_equal("TEST SPACE", @robot.get_reaction("SPACE TEST"))
    assert_equal('tiresia', @robot.get_reaction('get test 1'))
    assert_equal('TEST SPACE', @robot.get_reaction('justbeforethat tag test'))
    assert_equal('TEST SPACE', @robot.get_reaction('that tag test'))
    assert_equal('are you never tired to do the same things every day?', 
                 @robot.get_reaction('question test'))
    assert_equal('localhost', @robot.get_reaction('get test 2'))
    assert_equal('ok.', @robot.get_reaction('think test. i am male'))
    assert_equal('male.female.female', @robot.get_reaction('test set'))
    assert_equal('You sound very attractive.',@robot.get_reaction('I AM BLOND'))
    assert_equal('You sound very attractive.', @robot.get_reaction('I AM RED'))
    assert_equal('You sound very attractive.',@robot.get_reaction('I AM BLACK'))
    assert_equal('The sentence test', @robot.get_reaction('sentence test'))
    assert_equal('The Formal Test', @robot.get_reaction('formal test'))
    assert_equal('A', @robot.get_reaction('random test'))
    assert_equal('RANDOM TEST.FORMAL TEST', @robot.get_reaction('test input'))
    assert_equal(
              'she told to him to take a hike but her ego was too much for him',
                 @robot.get_reaction('test gender'))
    assert_equal('she TOLD to him', 
                 @robot.get_reaction('gender test 2 he told to her'))
    assert_equal(
           'she TOLD MAURO EVERYTHING OK WITH her PROBLEM BUT i answers no', 
                 @robot.get_reaction(
                'i told mauro everything ok with my problem but he answers no'))
    assert_equal('i say everything ok to you', 
                  @robot.get_reaction('you say everything ok to me'))
    assert_equal('star wins', @robot.get_reaction('This is her'))
    assert_equal('underscore wins', @robot.get_reaction('This is you'))
    assert_equal('explicit pattern wins', 
                 @robot.get_reaction('This is clearly you'))
    assert_equal('first star is ARE NEAT AND second star is GOOD AS', 
                 @robot.get_reaction('These are neat and clearly good as them'))
    assert_equal('WHAT IS YOUR FAVORITE FOOTBALL TEAM', 
                 @robot.get_reaction('test thatstar'))
    assert_equal('ALSO MINE IS AC MILAN', @robot.get_reaction('AC milan'))
    assert_equal('WHAT IS YOUR FAVORITE FOOTBALL TEAM', 
                 @robot.get_reaction('test thatstar'))
    assert_equal('ok yes ALSO MINE IS AC MILAN', 
                 @robot.get_reaction('yes AC milan'))
  end
end
