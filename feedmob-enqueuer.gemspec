Gem::Specification.new do |s|
  s.name        = 'feedmob-enqueuer'
  s.version     = '0.0.0'
  s.date        = '2019-09-05'
  s.summary     = ""
  s.description = ""
  s.authors     = ["feedmob"]
  s.email       = 'kun@feedmob.com'
  s.files       = ["lib/sidekiq-enqueuer.rb"]
  s.license     = 'MIT'
  s.add_development_dependency 'minitest', '~> 0'
  s.add_development_dependency 'sidekiq', '~> 0'
end
