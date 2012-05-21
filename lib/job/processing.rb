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
    require 'aws/s3'
    ::AWS::S3::Base.establish_connection!(
      :access_key_id => Pandrino.aws_s3[:access_key_id],
      :secret_access_key => Pandrino.aws_s3[:secret_access_key]
    )
    self.result_files.each do |file_path|
      new_file_path = options[:destination]
      ::AWS::S3::S3Object.store(new_file_path, open(file_path), Pandrino.aws_s3[:bucket], :access => :public_read)
      raise 'File was not uploaded to S3' unless ::AWS::S3::S3Object.exists? new_file_path, Pandrino.aws_s3[:bucket]
      medias << Media.create(:type => self.get_media_type, :location => new_file_path, :origin_media_id => origin_id)
    end
    medias
  end

  def update_media
    media = Media.find(options[:media_id])
    require 'aws/s3'
    ::AWS::S3::Base.establish_connection!(
      :access_key_id => Pandrino.aws_s3[:access_key_id],
      :secret_access_key => Pandrino.aws_s3[:secret_access_key]
    )
    ::AWS::S3::S3Object.delete(media.location, Pandrino.aws_s3[:bucket])
    ::AWS::S3::S3Object.store(media.location, open(self.result_files.first), Pandrino.aws_s3[:bucket])
    raise 'File was not uploaded to S3' unless ::AWS::S3::S3Object.exists? media.location, Pandrino.aws_s3[:bucket]
    media
  end

  def perform
    raise "Not implemented"
  end

  def media_type
    raise "Not implemented"
  end

  def get_media_type
    options[:media_type] || media_type
  end
end
