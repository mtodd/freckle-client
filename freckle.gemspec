Gem::Specification.new do |s|
  s.name = "freckle"
  s.version = "0.0.2"
  
  s.authors = ["Matt Todd"]
  s.email = "mtodd@highgroove.com"
  
  s.date = "2010-10-23"
  s.description = "Let's Freckle API Client"
  s.summary = "A Ruby client for the Let's Freckle API"
  
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README.textile",
    "Rakefile",
    "lib/freckle.rb",
    "test/fixtures/entries.json",
    "test/fixtures/entries_for_project.json",
    "test/fixtures/entries_for_user.json",
    "test/fixtures/projects.json",
    "test/fixtures/users.json",
    "test/freckle_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = "http://github.com/mtodd/freckle"
  
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.6"
  
  s.test_files = [
    "test/freckle_test.rb",
    "test/test_helper.rb"
  ]
  
  s.add_runtime_dependency("rest-client", ["= 1.6.1"])
  s.add_runtime_dependency("json", ["= 1.4.6"])
  
  s.add_development_dependency(%q<fakeweb>, ["= 1.3.0"])
  
end
