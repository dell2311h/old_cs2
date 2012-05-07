class TempStorage

  attr :encoding_id, :output_dir_name

  def initialize encoding_id, output_dir_name = nil
    @encoding_id = encoding_id
    @output_dir_name = output_dir_name
    make_output_dir!
  end

  def encoding_dir_fullpath
    "#{Pandrino.encoded_media_path}/#{self.encoding_id}"
  end

  def output_dir_fullpath
    "#{self.encoding_dir_fullpath}/#{self.output_dir_name}" if output_dir_name
  end

  private

    def make_output_dir!
      Dir.mkdir(Pandrino.encoded_media_path) unless File.directory? Pandrino.encoded_media_path
      Dir.mkdir(self.encoding_dir_fullpath) unless File.directory? self.encoding_dir_fullpath
      Dir.mkdir(self.output_dir_fullpath) unless File.directory? self.output_dir_fullpath if output_dir_name
    end
end
