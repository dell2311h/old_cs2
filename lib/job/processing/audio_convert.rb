class Job::AudioConvert < Job::Processing

  def perform
    input_file = input_files_array[0]
    raise "format is not provided" unless options[:format]
    raise "Empty input file" unless input_file

    output_file = "#{self.output_dir}/#{SecureRandom.uuid}.#{options[:format]}"

    recipe = "lame #{input_file} #{output_file}"
    raise 'Failed to convert file' unless system recipe
    log("Convert audio from #{input_file} to #{output_file}")
    self.result_files = [output_file]
  end

  def media_type
    'audio'
  end

end
