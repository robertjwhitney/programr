module ProgramR
class History
  @@topic      = 'default'
  @@inputs     = []
  @@responses  = []
  @@starGreedy = []
  @@thatGreedy = []
  @@topicGreedy = []

  def topic; @@topic end
  
  def that
    return 'undef' unless @@responses[0]
    @@responses[0] 
  end
  
  def justbeforethat 
    return 'undef' unless @@responses[1]
    @@responses[1] 
  end
  
  def justthat 
    return 'undef' unless @@inputs[0]
    @@inputs[0] 
  end
  
  def beforethat 
    return 'undef' unless @@inputs[1]
    @@inputs[1] 
  end
  
  def getStar(anIndex) 
    return 'undef' unless @@starGreedy[anIndex]
    @@starGreedy[anIndex].join(' ') 
  end

  def getThatStar(anIndex) 
    return 'undef' unless @@thatGreedy[anIndex]
    @@thatGreedy[anIndex].join(' ') 
  end
  
  def getTopicStar(anIndex) 
    return 'undef' unless @@topicGreedy[anIndex]
    @@topicGreedy[anIndex].join(' ') 
  end

  def updateTopic(aTopic)
    @@topic = aTopic
  end

  def updateResponse(aResponse)
    @@responses.unshift(aResponse)
  end

  def updateStimula(aStimula)
    @@inputs.unshift(aStimula)
  end

  def getStimula(anIndex)
    @@inputs[anIndex]
  end
  
  def updateStarMatches(aStarGreedyArray)
    @@starGreedy = []
    @@thatGreedy = []
    @@topicGreedy = []
    currentGreedy = @@starGreedy
    aStarGreedyArray.each do |greedy|
      if(greedy == '<that>')
        currentGreedy = @@thatGreedy
      elsif(greedy == '<topic>')
        currentGreedy = @@topicGreedy
      elsif(greedy == '<newMatch>')
        currentGreedy.push([])
      else
        currentGreedy[-1].push(greedy)
      end
    end
  end
end
end

