require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/unit'
require 'minitest/pride'
require 'rack/test'
require 'active_job'
require 'sidekiq'
require 'pry'
require 'sidekiq/enqueuer'

Sidekiq.logger.level = Logger::ERROR
REDIS = Sidekiq::RedisConnection.create(url: 'redis://localhost/15')
ActiveJob::Base.queue_adapter = :sidekiq
ActiveJob::Base.logger.level = Logger::ERROR

class HardJob < ActiveJob::Base
  def perform(param1, param2)
  end
end

ENV['RACK_ENV'] = 'test'
