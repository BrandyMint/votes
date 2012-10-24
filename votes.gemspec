# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'votes/version'

Gem::Specification.new do |gem|
  gem.name          = "votes"
  gem.version       = Votes::VERSION
  gem.authors       = ["Danil Pismenny", "Alexander Logunov"]
  gem.email         = ["danil@orionet.ru", "unlovedru@gmail.com"]
  gem.description   = "Simple voting system"
  gem.summary       = "Simple voting system"
  gem.homepage      = "https://github.com/BrandyMint/votes"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sqlite3"

end
