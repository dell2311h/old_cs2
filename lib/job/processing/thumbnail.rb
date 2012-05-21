class Job::Thumbnail < Job::Processing

  def perform
    results = []
    self.input_files_array.each_with_index do |input_file, index|
      thumb_dir = "#{self.output_dir}/#{SecureRandom.uuid}/"
      Dir::mkdir(thumb_dir)
      thumbnail input_file, thumb_dir, options[:size][index]
      results << thumb_dir
    end

   self.result_files = results

  end

  def media_type
    'video'
  end

  private

    def thumbnail input, output, size
      recipe = "ffmpeg -itsoffset -2 -i $input_file$ -s #{size} -f image2 -r 1 #{output}thumb%d.jpg"
      transcoder = RVideo::Transcoder.new(self.input_files_array[0])
      transcoder.execute(recipe, {})

    end

end
