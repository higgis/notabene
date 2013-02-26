require "./lib/notabene"

Gem::Specification.new do |s|
  
  s.name        = 'notabene'
  s.version     = Notabene::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2013-02-26'
  s.summary     = "notabene-#{s.version}"
  s.description = "A simple script to turn a folder of *.md into *.html."
  s.authors     = ["James Higgs"]
  s.email       = 'jameshiggs@gmail.com'
  s.homepage    = 'https://github.com/higgis/notabene'

  #s.rubyforge_project         = "notabene"
  #s.required_rubygems_version = "> 1.3.6"

  s.add_dependency "redcarpet", "~> 2.0.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = ['lib']

end
