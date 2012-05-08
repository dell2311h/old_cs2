
class Job::Download < Job::Base

  attr :output_dir, :media_ids

  def initialize output_dir, media_ids, options = {}
    super(options)
    @output_dir = output_dir
    @media_ids = media_ids
  end

  def perform
    require 'aws/s3'
    ::AWS::S3::Base.establish_connection!(
      :access_key_id => Pandrino.aws_s3[:access_key_id],
      :secret_access_key => Pandrino.aws_s3[:secret_access_key]
    )
    output_files_array = []
    media_ids.each do |media_id|
      location = Media.find(media_id).location
      raise 'File not exists on S3' unless ::AWS::S3::S3Object.exists? location, Pandrino.aws_s3[:bucket]
      media_file = ::AWS::S3::S3Object.value location, Pandrino.aws_s3[:bucket]
      extension = File.extname location
      new_file_path = "#{self.output_dir}/#{SecureRandom.uuid}#{extension}"
      File.open(new_file_path, "wb") do |new_file|
        new_file.write(media_file)
      end
      raise 'File not exists' unless File.exists? new_file_path
      output_files_array << new_file_path
    end
    self.result_files = output_files_array
  end

end
