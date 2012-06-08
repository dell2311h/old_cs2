class Job::Bitrate < Job::Processing

  def perform
    params = { :output_file => "#{self.output_dir}/#{SecureRandom.uuid}.mp4" }
    raise 'Invalid bitrate value' if (bitrate = self.options[:bitrate]).nil?
    recipe = "ffmpeg -i $input_file$ -b:v #{bitrate}k $output_file$"
    transcoder = RVideo::Transcoder.new(self.input_files_array[0])
    transcoder.execute(recipe, params)
    log("Set bitrate to #{bitrate} for '#{self.input_files_array[0]}' and save to #{params[:output_file]}")
    self.result_files = [params[:output_file]]
  end

  def media_type
    'video'
  end

end
