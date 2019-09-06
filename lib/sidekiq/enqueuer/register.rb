module Sidekiq
  module Enqueuer
    module Register
      def self.registered(app)
        view_path = File.join(File.expand_path('..', __FILE__), 'view')

        app.get '/enqueuer' do
          @jobs = Model::Job.all_jobs
          render(:erb, File.read(File.join(view_path, 'index.erb')))
        end

        app.get '/enqueuer/:job_class_name' do
          @job = Model::Job.find_by_class_name(params[:job_class_name])
          render(:erb, File.read(File.join(view_path, 'new.erb')))
        end

        app.post '/enqueuer' do
          job = Model::Job.find_by_class_name(params[:job_class_name])
          if job
            if params['wait_second'].blank?
              job.perform_now(params['perform'])
            else
              job.perform_in(params['perform'], params['wait_second'].to_i)
            end
          end
          redirect "#{root_path}enqueuer"
        end
      end
    end
  end
end
