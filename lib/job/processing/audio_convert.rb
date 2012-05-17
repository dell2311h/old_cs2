class Job::AudioConvert < Job::Processing

  def perform
    input_file = input_files_array[0]
    raise "format is not provided" unless options[:format]
    raise "Empty input file" unless input_file

    output_file = "#{self.output_dir}/#{SecureRandom.uuid}.#{options[:format]}"

    recipe = "ffmpeg -i #{input_file} #{output_file}"
    params = { output_file: output_file }

    transcoder = RVideo::Transcoder.new(input_file)
    transcoder.execute(recipe, params)

    self.result_files = [output_file]
  end

  def media_type
    'audio'
  end

end

