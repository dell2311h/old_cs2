require 'aws/s3'

class Job::Download < Job::Base

  attr :output_dir, :media_ids

  def initialize output_dir, media_ids, options = {}
    super(options)
    @output_dir = output_dir
    @media_ids = media_ids
  end

  def perform
    output_files_array = []
    media_ids.each do |media_id|
      location = Media.find(media_id).location
      raise 'File not exists on S3' unless S3Object.exists? location, 'crowdsync-development'
      media_file = S3Object.value location, 'crowdsync-development'
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
