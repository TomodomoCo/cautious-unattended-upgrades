Gem::Specification.new do |s|
  s.name        = 'cautious_unattended_upgrades'
  s.version     = '0.0.1'
  s.date        = '2015-08-21'
  s.summary     = "A test suite for Debian unattended-upgrades"
  s.description = "Allows automated testing following Debian unattended-upgrades. If everything succeeds, can 'push' the recently installed package list to its clients, so they will install the upgrades."
  s.authors     = ["Peter Upfold"]
  s.email       = 'peter@vanpattenmedia.com'
  s.files       = ["lib/cautious_unattended_upgrades.rb"]
  s.homepage    =
    'https://github.com/vanpattenmedia/cautious-unattended-upgrades'
  s.license       = 'BSD'
end
