class Job::Rotate < Job::Processing

  def perform
    params = { :output_file => "#{self.output_dir}/#{SecureRandom.uuid}.mp4" }

    recipe = case self.options[:angle].to_i
      when 90
        "ffmpeg -i $input_file$ -vf 'transpose=1' $output_file$"
      when 180
        'ffmpeg -i $input_file$ -vf "vflip, hflip" $output_file$'
      when 270
        "ffmpeg -i $input_file$ -vf 'transpose=2' $output_file$"
      else
        raise 'Invalid angle (only: 90, 180, 270)'
    end

    transcoder = RVideo::Transcoder.new(self.input_files_array[0])
    transcoder.execute(recipe, params)
    log("Rotate video '#{self.input_files_array[0]}' with angle #{self.options[:angle].to_i} to #{params[:output_file]}")
    self.result_files = [params[:output_file]]
  end

  def media_type
    'video'
  end

end
