require 'test_helper'

module Sidekiq
  module Enqueuer
    module Model
      describe Job do
        include Rack::Test::Methods

        describe 'Job#all_jobs' do
          it 'will list valid job' do
            class Sidekiq::Extensions::DelayedModel < ActiveJob::Base
              def perform(param1, param2)
              end
            end

            jobs = Job.all_jobs
            assert_equal 'HardJob', jobs.first.name
            assert_equal 1, jobs.count
          end
        end

        describe 'Job#find_by_class_name' do
          it 'search right job' do
            job = Job.find_by_class_name 'HardJob'
            assert_equal 'HardJob', job.name
          end

          it 'return nil if no job' do
            job = Job.find_by_class_name 'NoThisJob'
            assert_nil job
          end
        end

      end
    end
  end
end
