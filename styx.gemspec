Gem::Specification.new do |s|
  s.name        = "styx"
  s.version     = "0.1.2"
  s.platform    = Gem::Platform::RUBY  
  s.summary     = "Set of helpers to maintain bridge between Server (Rails) side and Client (JS) side"
  s.email       = "boris@roundlake.ru"
  s.homepage    = "http://github.com/inossidabile/styx"
  s.description = s.summary
  s.authors     = ['Boris Staal', 'Alexander Pavlenko']

  s.has_rdoc = false # disable rdoc generation until we've got more
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'combustion', '~> 0.3.1'
  s.add_development_dependency 'rspec-rails', '~> 2.8.1'
  s.add_development_dependency 'capybara', '~> 1.1.2'
end
