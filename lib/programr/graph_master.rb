require 'programr/aiml_elements'

module ProgramR
THAT  = '<that>'
TOPIC = '<topic>'
class GraphMaster
  attr_reader :graph
  def initialize
    @graph = Node.new
  end

  def merge(aCache)
    @graph.merge(aCache.graph)
  end
  
  def learn(category)
    path = category.get_pattern
    path += [THAT] + category.get_that unless (category.get_that).empty?
    path += [TOPIC] + category.topic.split(/\s+/) if category.topic
    @graph.learn(category, path)
  end

  def to_s
    @graph.inspectNode()
  end

  def get_reaction(stimula, last_said,cur_topic,starGreedy)
    path = "#{stimula} #{THAT} #{last_said} #{TOPIC} #{cur_topic}"
    template = @graph.get_template(path.split(/\s+/),starGreedy)
    return template.value unless(template == nil)
    return []
  end
end

class Node
  attr_reader :children
  def initialize
    @template = nil
    @children = {}
  end

  def merge(aCache)
    aCache.children.keys.each do |key|
      if(@children.key?(key))
        @children[key].merge(aCache.children[key])
	next
      end
      @children[key] = aCache.children[key]
    end
  end
  
  def learn(category, path)
    branch = path.shift
    return @template = category.template unless branch
    @children[branch] = Node.new unless @children[branch]
    @children[branch].learn(category, path)
  end

  def get_template(pattern,starGreedy,isGreedy=false)  
    currentTemplate = nil
    gotValue        = nil
    curGreedy       = []
    if(@template)
      if(isGreedy)
	starGreedy.push(pattern.shift) until(pattern.empty?||pattern[0]==THAT ||
	                                     pattern[0] == TOPIC)
      end
      return @template if(pattern.empty?)
      currentTemplate = @template if(pattern[0] == THAT || pattern[0] == TOPIC)
    end
    branch = pattern.shift
    isGreedy = false if(branch == THAT || branch == TOPIC)
    unless(branch != THAT || @children.key?(THAT))
      branch = pattern.shift until (branch == nil or branch == TOPIC)
    end
    return nil unless(branch)
    if(@children[branch])
      gotValue = @children[branch].get_template(pattern.clone,curGreedy)
    elsif(isGreedy)
      curGreedy.push(branch)
      gotValue = get_template(pattern.clone,curGreedy,true)
    end
    if(gotValue)
      starGreedy.push(branch) if(branch == THAT || branch == TOPIC)
      starGreedy.concat(curGreedy)
      return gotValue
    end
    return currentTemplate if currentTemplate   
    ["_","*"].each do |star|
      next unless(@children.key?(star))
      next unless(gotValue=@children[star].get_template(pattern.clone,
                                                        curGreedy,true))
starGreedy.push(branch) if(branch == THAT || branch == TOPIC)
      starGreedy.concat(['<newMatch>',branch].concat(curGreedy))
      return gotValue 
    end
    return nil
  end

  def inspectNode(nodeId = nil, ind = 0)
    str = ''
    str += '| '*(ind - 1) + "|_#{nodeId}" unless ind == 0
    str += ": [#{@template.inspect}]" if @template
    str += "\n" unless ind == 0
    @children.each_key{|c| str += @children[c].inspectNode(c, ind+1)}
    str
  end
end

end #ProgramR
