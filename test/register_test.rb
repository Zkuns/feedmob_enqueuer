require 'test_helper'
require 'sidekiq/web'

module Sidekiq
  module Enqueuer
    describe Register do
      include Rack::Test::Methods

      def app
        Sidekiq::Web
      end

      before do
        Sidekiq.redis = REDIS
        Sidekiq.redis(&:flushdb)
      end

      describe 'register index page' do
        it 'can display home page' do
          get '/enqueuer'
          last_response.status.must_equal 200
        end
      end

      describe 'register new page' do
        it 'can display HardJob form' do
          get '/enqueuer/HardJob'

          last_response.body.must_match 'HardJob'
          last_response.body.must_match 'param1'
          last_response.body.must_match 'param2'
        end
      end

      describe 'register post page' do
        it 'post form, enqueue a HardJob' do
          default_queue = Sidekiq::Queue.new(:default)

          post '/enqueuer', job_class_name: 'HardJob',
                              perform: { param1: 'v1', param2: 'v2' }
          last_response.status.must_equal 302

          assert_equal 'HardJob', default_queue.first.args.first['job_class']
          assert_equal ['v1', 'v2'], default_queue.first.args.first['arguments']
        end

        it 'post form, schedule a HardJob' do
          ss = Sidekiq::ScheduledSet.new

          post '/enqueuer', job_class_name: 'HardJob',
                           perform: { param1: 'v1', param2: 'v2' },
                           wait_second: 120
          last_response.status.must_equal 302

          assert_equal ['v1', 'v2'], ss.first.args.first['arguments']
          assert_equal 120, (ss.first.at - Time.now).ceil
        end
      end

    end
  end
end
