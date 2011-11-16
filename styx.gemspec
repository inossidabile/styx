SPEC = Gem::Specification.new do |s|
  s.name        = "styx"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY  
  s.summary     = "Styx is set of helpers to maintain bridge between Rails and Browser (JS)"
  s.email       = "boris@roundlake.ru"
  s.homepage    = "http://github.com/roundlake/styx"
  s.description = "Styx is set of helpers to maintain bridge between Rails and Browser (JS)"
  s.authors     = ['Round Lake', 'Boris Staal']

  s.has_rdoc = false # disable rdoc generation until we've got more
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
