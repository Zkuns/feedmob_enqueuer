module Sidekiq
  module Enqueuer
    module Model
      class Job
        attr_accessor :job, :name, :params
        IGNORED_CLASSES = %w(Sidekiq::Extensions
                           Sidekiq::Extensions::DelayedModel
                           Sidekiq::Extensions::DelayedMailer
                           Sidekiq::Extensions::DelayedClass
                           ActiveJob::QueueAdapters).freeze

        def initialize(job_class)
          @job = job_class
          @name = job_class.name
          @params = get_params
        end

        def perform_now request_params
          @job.perform_later(*parse_params(request_params))
        end

        def perform_in request_params, time_in_second
          @job.set(wait: time_in_second).perform_later(*parse_params(request_params))
        end

        class << self
          attr_accessor :jobs

          def all_jobs
            return @jobs unless @jobs.blank?
            @jobs = ObjectSpace.each_object(Class).select { |k| k.superclass == ::ActiveJob::Base }.map {|j| Sidekiq::Enqueuer::Model::Job.new(j) }
            (@jobs = @jobs + ObjectSpace.each_object(Class).select { |k| k.superclass == ApplicationJob }) if (defined? ApplicationJob)
            @jobs.delete_if { |j| IGNORED_CLASSES.include?(j.name) }
            @jobs
          end

          def find_by_class_name name
            all_jobs.each do |job|
              return job if job.name == name
            end
            nil
          end
        end

        private

        def parse_params request_params
          Param.check_params request_params, @params
        end

        def get_params
          method_name = get_evaluate_name
          job.instance_method(method_name).parameters.map do |method_data|
            Param.new(method_data[1], method_data[0])
          end
        end

        def get_evaluate_name
          [:perform, :perform_in, :perform_async, :perform_at].each do |method_name|
            return method_name if job.instance_methods.include?(method_name)
          end
          nil
        end

      end
    end
  end
end
