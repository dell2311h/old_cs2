class Job::Processing < Job::Base

  attr :input_files_array, :output_dir

  def initialize input_files_array, output_dir, options = {}
    raise "Can't initialize an abstract class instance" if self.class == Job::Processing
    super(options)
    @input_files_array = input_files_array
    @output_dir = output_dir
  end

  def create_medias(origin_id = nil)
    medias = []
    self.result_files.each do |file_path|
      extension = File.extname file_path
      p file_path
      new_file_path = "#{Padrino.root}/spec/fixtures/S3_bucket/results/#{SecureRandom.uuid}#{extension}"
      FileUtils.copy(file_path, new_file_path)
      medias << Media.create(:type => self.media_type, :location => new_file_path, :origin_id => origin_id)
    end
    medias
  end

  def perform
    raise "Not implemented"
  end

  def media_type
    raise "Not implemented"
  end

end
