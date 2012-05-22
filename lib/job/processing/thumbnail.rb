class Job::Thumbnail < Job::Processing

  def perform
    results = []
    input_file = self.input_files_array[0]
    thumbnail input_file, self.output_dir, options[:size]
    self.result_files = Dir.glob("#{self.output_dir}/#{self.file_name_template}*.*")
  end

  def media_type
    'thumbnails'
  end

  def file_name_template
    options[:thumbnail_name] || 'thumb'
  end

  def create_medias(origin_id = nil)
    require 'aws/s3'
    ::AWS::S3::Base.establish_connection!(
      :access_key_id => Pandrino.aws_s3[:access_key_id],
      :secret_access_key => Pandrino.aws_s3[:secret_access_key]
    )
    self.result_files.each do |file_path|
      new_file_path = "#{options[:destination]}/#{File.basename(file_path)}"
      ::AWS::S3::S3Object.store(new_file_path, open(file_path), Pandrino.aws_s3[:bucket], :access => :public_read)
      raise 'File was not uploaded to S3' unless ::AWS::S3::S3Object.exists? new_file_path, Pandrino.aws_s3[:bucket]
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

