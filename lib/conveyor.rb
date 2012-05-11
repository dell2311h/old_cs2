class Conveyor
  @queue = :conveyor
  @@jobs_results = {}
  @@create_medias_for_jobs = []
  @@new_medias = []

  class << self
    def perform(encoding_id)
      encoding = Encoder.find encoding_id
      storage = TempStorage.new encoding_id, "downloads"
      download = Job::Download.new storage.output_dir_fullpath, encoding.input_media_ids
      add_job_result :download, download.perform

      encoding.profile.commands.asc(:ordering_number).each do |command|
        processing_job = initiate_job_by command, encoding
        add_job_result command.ordering_number, processing_job.perform
        @@create_medias_for_jobs << processing_job if command.create_media
      end

      @@create_medias_for_jobs
      @@create_medias_for_jobs.each do |job|
        @@new_medias << job.create_medias(encoding.params['destination'], encoding.input_media_ids.first)
        @@new_medias.flatten!
      end

      encoding.result_media_ids = @@new_medias.map(&:id)
      encoding.save
      encoding.notifications.create(
                        :callback_url => "#{Pandrino.callback_url}/#{encoding.profile.name}",
                        :data => {:status => 'ok'})
      # TODO delete tmpfiles
    end

    def add_job_result(job_number, result)
      @@jobs_results.[]= job_number, result
    end

    def set_input_data_for command
      input_number = command.input_from_command_with_number
      @@jobs_results[input_number ? input_number : :download]
    end

    def prepare_options_for command, params
      prepared_options = {}
      command.options.each do |option|
        value = (option.params_key_name && params[option.params_key_name]) ? params[option.params_key_name] : option.value
        prepared_options.[]= option.key.to_sym, value
      end
      prepared_options
    end

    def initiate_job_by command, encoding
      job_klass = "Job::#{command.job_name.camelize}".constantize
      storage = TempStorage.new encoding.id, command.ordering_number
      job_klass.new set_input_data_for(command), storage.output_dir_fullpath, prepare_options_for(command, encoding.params)
    end
  end

end
