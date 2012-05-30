
class Job::Download < Job::Base

  attr :output_dir, :media_ids

  def initialize output_dir, media_ids, options = {}
    super(options)
    @output_dir = output_dir
    @media_ids = media_ids
  end

  def perform
    output_files_array = []
    @media_ids.each do |media_id|
      media = Media.find(media_id)
      location = media.location
      storage = media.origin_media_id.nil? ? Storage::Factory.initialize_storage(:aws_s3) : PANDRINO_STORAGE
      raise "File not exists in location: '#{location}'" unless storage.file_exist? location
      new_file_path = "#{self.output_dir}/#{SecureRandom.uuid}#{File.extname(location)}"
      storage.download location, new_file_path
      raise "File was not downloaded to location: '#{new_file_path}'" unless File.exists? new_file_path
      output_files_array << new_file_path
    end
    self.result_files = output_files_array
  end

end
