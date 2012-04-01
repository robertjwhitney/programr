module ProgramR
  module Cache
  def self.dumping(aFilename,theGraphMaster)
    File.open(aFilename,'w') do |file|
      file.write(Marshal.dump(theGraphMaster,-1))
    end
  end

  def self.loading(aFilename)
    File.open(aFilename,'r') do |file|
      return Marshal.load(file.read)
    end rescue nil
  end
  end # module Cache

  module AimlFinder
    # Returns an array of aiml files recursively found
    def self.find(files_and_dirs)
      files = []
      files_and_dirs.each{|file|
        if File.file?(file) && (file  =~ /.*\.aiml$/)
          files << file
          next
        end
        files += find(Dir.glob("#{file}/*"))
      }
      files
    end
  end
end #module ProgramR
