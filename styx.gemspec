SPEC = Gem::Specification.new do |s|
  s.name        = "styx"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY  
  s.summary     = "Styx is a set of helpers to maintain bridge between Server (Ruby) side and Client (JS) side"
  s.email       = "boris@roundlake.ru"
  s.homepage    = "http://github.com/roundlake/styx"
  s.description = s.summary
  s.authors     = ['Boris Staal']

  s.has_rdoc = false # disable rdoc generation until we've got more
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end