require 'rexml/parsers/sax2parser'
require 'programr/aiml_elements'

# gli accenti nel file di input vengono trasformati in &apos; !!!
#
module  ProgramR
class AimlParser
  def initialize(learner); @learner = learner end

  def parse(aiml)
    @parser = REXML::Parsers::SAX2Parser.new(aiml)
    category         = nil
    openLabels       = []
    patternIsOpen    = false
    thatIsOpen       = false
    currentSetLabel  = nil
    currentCondition = nil
    currentSrai      = nil
    currentGender    = nil
    currentPerson    = nil
    currentPerson2   = nil
    currentTopic     = nil

    @parser.listen(%w{ category }){|uri,localname,qname,attributes| 
      category = Category.new
      category.topic = currentTopic if(currentTopic)
    }

    @parser.listen(['topicstar','thatstar','star']){|u,localname,qn,attributes|
      openLabels[-1].add(Star.new(localname,attributes))
    }

### condition -- random
    @parser.listen(%w{ condition }){|uri,localname,qname,attributes|
      if(attributes.key?('value'))
        currentCondition = Condition.new(attributes)
      else
        currentCondition = ListCondition.new(attributes)
      end
      openLabels[-1].add(currentCondition)
      openLabels.push(currentCondition)
    }
    
    @parser.listen(%w{ random }){|uri,localname,qname,attributes|
      currentCondition = Random.new
      openLabels[-1].add(currentCondition)
      openLabels.push(currentCondition)
    }
    
    @parser.listen(:characters, %w{ condition }){|text|
      next if(text =~ /^\s+$/)
      currentCondition.add(text)
    }

    @parser.listen(%w{ li }){|uri,localname,qname,attributes|
      next unless currentCondition
      currentCondition.setListElement(attributes)
    }
    
    @parser.listen(:characters,%w{ li }){|text|
      next unless currentCondition
      currentCondition.add(text)
    }

    @parser.listen(:end_element, ['condition','random']){
      currentCondition = nil
      openLabels.pop      
    }
### end condition -- random

    @parser.listen([/^get.*/,/^bot_*/,'for_fun',/that$/, 'question']){
                   |uri,localname,qname,attributes|
      unless(openLabels.empty?)
        openLabels[-1].add(ReadOnlyTag.new(localname, attributes))
      end
    }

    @parser.listen(['bot','name']){|uri,localname,qname,attributes|
      if(localname == 'bot')
        localname = 'bot_'+attributes['name']
      else
        localname = 'bot_name'
      end
      if(patternIsOpen)
        category.add_pattern(ReadOnlyTag.new(localname, {}))
      elsif(thatIsOpen)
        category.add_that(ReadOnlyTag.new(localname, {}))
      else
        openLabels[-1].add(ReadOnlyTag.new(localname, {}))
      end
    }

### set
    @parser.listen([/^set_*/,'set']){|uri,localname,qname,attributes|
      setObj = SetTag.new(localname,attributes)    
      openLabels[-1].add(setObj)
      openLabels.push(setObj)
    }

    @parser.listen(:characters,[/^set_*/]){|text|
      openLabels[-1].add(text)    
    }

    @parser.listen(:end_element, [/^set_*/,'set']){
      openLabels.pop      
    }
### end set

### pattern
    @parser.listen(%w{ pattern }){patternIsOpen = true}
    @parser.listen(:characters,%w{ pattern }){|text| 
      #TODO verify if case insensitive. Cross check with facade
      category.add_pattern(text.upcase)
    }
    @parser.listen(:end_element, %w{ pattern }){patternIsOpen = false}
#end pattern

#### that
    @parser.listen(%w{ that }){thatIsOpen = true}
    @parser.listen(:characters,%w{ that }){|text| category.add_that(text)}
    @parser.listen(:end_element, %w{ that }){thatIsOpen = false}
### end that

### template
    @parser.listen(%w{ template }){ 
      category.template = Template.new 
      openLabels.push(category.template)
    }

    @parser.listen(:characters, %w{ template }){|text|
      category.template.append(text)
    }

    @parser.listen(:end_element, %w{ template }){
      openLabels.pop
    }
### end template

    @parser.listen(%w{ input }){|uri,localname,qname,attributes|
      category.template.add(Input.new(attributes))
    }

### think
    @parser.listen(:start_element, %w{ think }){
      openLabels[-1].add(Think.new('start'))
    }

    @parser.listen(:end_element, %w{ think }){
    openLabels[-1].add(Think.new('end'))
    }
###end think

    @parser.listen(:characters, %w{ uppercase }){|text|
      openLabels[-1].add(text.upcase.gsub(/\s+/, ' '))
    }

    @parser.listen(:characters, %w{ lowercase }){|text|
      openLabels[-1].add(text.downcase.gsub(/\s+/, ' '))
    }

    @parser.listen(:characters, %w{ formal }){|text|
      text.gsub!(/(\w+)/){$1.capitalize}
      openLabels[-1].add(text.gsub(/\s+/, ' '))
    }

    @parser.listen(:characters, %w{ sentence }){|text|
      openLabels[-1].add(text.capitalize.gsub(/\s+/, ' '))
    }

    @parser.listen(%w{ date }){
      openLabels[-1].add(Sys_Date.new)
    }
    
    @parser.listen(:characters, %w{ system }){|text|
      openLabels[-1].add(Command.new(text))
    }
    
    @parser.listen(%w{ size }){ 
      openLabels[-1].add(Size.new)
    }

    @parser.listen(%w{ sr }){|uri,localname,qname,attributes|
      openLabels[-1].add(Srai.new(Star.new('star',{})))
    }
### srai    
    @parser.listen(%w{ srai }){|uri,localname,qname,attributes|
      currentSrai = Srai.new
      openLabels[-1].add(currentSrai)
      openLabels.push(currentSrai)
    }
    
    @parser.listen(:characters, %w{ srai }){|text|
      currentSrai.add(text)
    }
    
    @parser.listen(:end_element, %w{ srai }){
      currentSrai = nil
      openLabels.pop
    }
### end srai

### gender
    @parser.listen(%w{ gender }){|uri,localname,qname,attributes|
      currentGender = Gender.new
      openLabels[-1].add(currentGender)
      openLabels.push(currentGender)
    }
    
    @parser.listen(:characters, %w{ gender }){|text|
      currentGender.add(text)
    }

    @parser.listen(:end_element, %w{ gender }){
      currentGender = nil
      openLabels.pop
    }
### end gender

### person
    @parser.listen(%w{ person }){|uri,localname,qname,attributes|
      currentPerson = Person.new
      openLabels[-1].add(currentPerson)
      openLabels.push(currentPerson)
    }
    
    @parser.listen(:characters, %w{ person }){|text|
      currentPerson.add(text)
    }

    @parser.listen(:end_element, %w{ person }){
      currentPerson = nil
      openLabels.pop
    }
### end person

### person2
    @parser.listen(%w{ person2 }){|uri,localname,qname,attributes|
      currentPerson2 = Person2.new
      openLabels[-1].add(currentPerson2)
      openLabels.push(currentPerson2)
    }
    
    @parser.listen(:characters, %w{ person2 }){|text|
      currentPerson2.add(text)
    }

    @parser.listen(:end_element, %w{ person2 }){
      currentPerson2 = nil
      openLabels.pop
    }
### end perso2

    @parser.listen(:end_element, %w{ category }){ @learner.learn(category) }

### topic
    @parser.listen(%w{ topic }){|uri,localname,qname,attributes|
      currentTopic = attributes['name']
    }
    
    @parser.listen(:end_element, %w{ topic }){
      currentTopic = nil
    }
### end topic

    @parser.parse
  end
end #Aiml@parser
end
