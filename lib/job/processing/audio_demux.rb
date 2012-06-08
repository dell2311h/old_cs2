class Job::AudioDemux < Job::Processing

  def perform
    params = { :output_file => "#{self.output_dir}/#{SecureRandom.uuid}.wav" }
    recipe = "ffmpeg -i $input_file$ -vcodec copy -vn -y $output_file$"
    transcoder = RVideo::Transcoder.new(self.input_files_array[0])
    transcoder.execute(recipe, params)
    log("Demux audio from '#{self.input_files_array[0]}' to '#{params[:output_file]}'")
    self.result_files = [params[:output_file]]
  end

  def media_type
    'audio'
  end

end
