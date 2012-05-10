class Job::FrameRate < Job::Processing

  def perform
    params = { :output_file => "#{self.output_dir}/#{SecureRandom.uuid}.mp4" }
    raise 'Invalid framerate value' if (framerate = self.options[:framerate]).nil?
    recipe = "ffmpeg -i $input_file$ -r #{framerate} $output_file$"
    transcoder = RVideo::Transcoder.new(self.input_files_array[0])
    transcoder.execute(recipe, params)
    self.result_files = [params[:output_file]]
  end

  def media_type
    'video'
  end

end
