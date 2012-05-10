class Job::Cut < Job::Processing

  def perform

    self.result_files = []

    self.input_files_array.each_with_index do |input_file, index|
      out_file = "#{self.output_dir}/#{SecureRandom.uuid}.mp4"
      raise "Invalid options" if (options[index].nil? || !(options[index].is_a? Hash))
      start_time = options[index][:start_time]
      end_time = options[index][:end_time]
      raise "Invalid options" if start_time.nil? && end_time.nil?

      start, duration = calculate_timings start_time, end_time
      cut input_file, out_file, start, duration

      self.result_files.push out_file
    end

  end

  def media_type
    'video'
  end

  private

    def calculate_timings start_time, end_time
      start = start_time
      start = 0 if start_time.nil?
      formated_start = format_time start
      formated_duration = nil
      unless end_time.nil?
          duration = end_time - start
          formated_duration = format_time duration
      end

     [ formated_start, formated_duration ]
    end

    def format_time miliseconds
      ms = Float miliseconds
      time = Time.new 2000, 01, 01, 0, 0, 0
      time = time + ms / 1000

      time.strftime("%H:%M:%S.%3N")
    end

    def cut input_file, output_file, start_time, duration
      params = { output_file: output_file }
      recipe = "ffmpeg -sameq -i $input_file$  -ss #{start_time} " + (duration.nil? ? "" : " -t #{duration} ") + "$output_file$"
      p recipe
      transcoder = RVideo::Transcoder.new(input_file)
      transcoder.execute(recipe, params)
    end

end

