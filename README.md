# ProgramR

### Aside:

This is just a simple port of http://aiml-programr.rubyforge.org/ (authored in 2007), to something
a tiny bit more usable. No new code really, I just sorta took the necessary parts to turn it into a gem for curiosity's sake.

AIML itself seems pretty simple, and weak as far as pattern matching goes, but the ALICE bot has won the Loebner prize, so there's that.

### About:

ProgramR is a Ruby implementation of an interpreter for the Artificial Intelligence Markup Language (AIML) based on the work of Dr. Wallace and defined by the Alicebot and AIML Architecture Committee of the A.L.I.C.E. AI Foundation http://alicebot.org

Some of the ALICE AIML files have thrown parse errors with certain caraters in my tests, so a subset is available here: https://github.com/robertjwhitney/alice-programr


### Original Authors:

Mauro Cicio, Nicholas H.Tollervey and Ben Minton


## Installation

Add this line to your application's Gemfile:

    gem 'programr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install programr

You can find a set of ALICE AIML files hosted at http://code.google.com/p/aiml-en-us-foundation-alice

Some of them have thrown errors in my tests so a subset is available here: https://github.com/robertjwhitney/alice-programr

## Usage
```ruby
#programr_test.rb

require 'bundler'
Bundler.setup :default

require 'programr'

if ARGV.empty?
  puts 'Please pass a list of AIMLs and/or directories as parameters'
  puts 'Usage: ruby programr_test.rb {aimlfile|dir}[{aimlfile|dir}]...'
  exit
end

robot = ProgramR::Facade.new
robot.learn(ARGV)

while true
  print '>> '
  s = STDIN.gets.chomp
  reaction = robot.get_reaction(s)
  STDOUT.puts "<< #{reaction}"
end
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
