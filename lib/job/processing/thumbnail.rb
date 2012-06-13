class Job::Thumbnail < Job::Processing

  def perform
    results = []
    input_file = self.input_files_array[0]
    thumbnail input_file, self.output_dir, options[:size]
    log("Create thumbnails from '#{input_file}' to '#{self.output_dir}'")
    self.result_files = Dir.glob("#{self.output_dir}/#{self.file_name_template}*.*")
  end

  def media_type
    'thumbnails'
  end

  def file_name_template
    options[:thumbnail_name] || 'thumb'
  end

  def create_medias(origin_id = nil)
    self.result_files.each do |file_path|
      new_file_path = "#{PANDRINO_STORAGE.full_path(options[:destination])}/#{File.basename(file_path)}"
      PANDRINO_STORAGE.upload file_path, new_file_path
    end
    Media.create(:type => self.get_media_type, :location => options[:destination], :origin_media_id => origin_id)
  end

  private

    def thumbnail input, output, size
      recipe = "ffmpeg -itsoffset -2 -i #{input} -s #{size} -f image2 -r 1 #{output}/#{self.file_name_template}%d.jpg"
      transcoder = RVideo::Transcoder.new(input)
      transcoder.execute(recipe, {})
    end

end
