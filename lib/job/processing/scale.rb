class Job::Scale < Job::Processing

  def perform
    params = { :output_file => "#{self.output_dir}/#{SecureRandom.uuid}.mp4" }
    raise 'Invalid size params' if self.options[:height].nil? || self.options[:width].nil?
    height = self.options[:height]
    width  = self.options[:width]
    recipe = "ffmpeg -i $input_file$ -vf 'scale=iw*min(#{width}/iw\\,#{height}/ih):ih*min(#{width}/iw\\,#{height}/ih),pad=#{width}:#{height}:(#{width}-iw)/2:(#{height}-ih)/2' $output_file$"
    transcoder = RVideo::Transcoder.new(self.input_files_array[0])
    transcoder.execute(recipe, params)
    log("Scale video '#{self.input_files_array[0]}' with size #{width}x#{height} to #{params[:output_file]}")
    self.result_files = [params[:output_file]]
  end

  def media_type
    'video'
  end

end
