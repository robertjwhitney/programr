require 'programr/graph_master'
require 'programr/aiml_parser'
require 'programr/history'
require 'programr/utils'

module ProgramR
class Facade
  def initialize(cache = nil)
    @graph_master = GraphMaster.new
    @parser       = AimlParser.new(@graph_master)
    @history      = History.new
  end

  def learn(files)
    AimlFinder::find(files).each{|f| File.open(f,'r'){|f| @parser.parse f} }
  end

  def loading(theCacheFilename='cache')
    cache = Cache::loading(theCacheFilename)
    @graph_master = cache if cache
  end

  def merging(theCacheFilename='cache')
    cache = Cache::loading(theCacheFilename)
    @graph_master.merge(cache) if cache
  end

  def dumping(theCacheFilename='cache')
    Cache::dumping(theCacheFilename,@graph_master)
  end
  
  def get_reaction(stimula,firstStimula=true)
    starGreedy = []  
#TODO verify if case insensitive. Cross check with parser
    #@history.updateStimula(stimula.upcase) if(firstStimula)
@history.updateStimula(stimula.upcase) if(firstStimula)
    thinkIsActive = false
reaction = @graph_master.get_reaction(stimula.upcase, @history.that,
                                          @history.topic,starGreedy)
    @history.updateStarMatches(starGreedy)
    res = ''
    reaction.each{|tocken| 
      if(tocken.class == Srai)
        tocken = get_reaction(tocken.pattern,false)
        @history.updateStarMatches(starGreedy)
      end
      if tocken.class == Think
        thinkIsActive = ! thinkIsActive
        next
      end
      value = tocken.to_s
      res += value unless(thinkIsActive)
    }
    #TODO verify if case insensitive. Cross check with main program & parser
    @history.updateResponse(res.strip.upcase) if(firstStimula)
    return res.strip
  end

  def to_s
    @graph_master.to_s
  end  

  #  def getBotName()end
end
end
