class Job::AudioCut < Job::Processing

  def perform

    self.result_files = []

    self.input_files_array.each_with_index do |input_file, index|
      out_file = "#{self.output_dir}/#{SecureRandom.uuid}.wav"
      raise "cutting_timings key is not provided at options" unless options[:cutting_timings]
      raise "Invalid options" if (options[:cutting_timings][index].nil? || !(options[:cutting_timings][index].is_a? Hash))
      start_time = options[:cutting_timings][index]["start_time"].to_i
      end_time = options[:cutting_timings][index]["end_time"].to_i
      raise "Invalid options" if start_time.nil? && end_time.nil?

      start, duration = calculate_timings start_time, end_time
      cut input_file, out_file, start, duration

      self.result_files << out_file
    end

    self.result_files
  end

  def media_type
    'audio'
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
      transcoder = RVideo::Transcoder.new(input_file)
      transcoder.execute(recipe, params)
    end

end

