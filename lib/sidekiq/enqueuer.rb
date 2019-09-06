require 'sidekiq/web'
require 'sidekiq/enqueuer/register'
require 'sidekiq/enqueuer/model/Job'
require 'sidekiq/enqueuer/model/Param'

Sidekiq::Web.register Sidekiq::Enqueuer::Register
Sidekiq::Web.tabs['Enqueuer'] = 'enqueuer'
Sidekiq::Web.settings.locales << File.join(File.dirname(__FILE__), 'enqueuer/locales')
::Rails.application.eager_load! if defined?(::Rails) && ::Rails.respond_to?(:env) && !::Rails.env.production?

module Sidekiq
  module Enqueuer
  end
end
