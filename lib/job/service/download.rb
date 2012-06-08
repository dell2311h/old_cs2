
class Job::Download < Job::Base

  attr :output_dir, :media_ids

  def initialize output_dir, media_ids, options = {}
    super(options)
    @output_dir = output_dir
    @media_ids = media_ids
  end

  def perform
    output_files_array = []
    log("Start download medias: #{media_ids.inspect}")
    @media_ids.each do |media_id|
      media = Media.find(media_id)
      location = media.location
      storage = PANDRINO_STORAGE
      new_file_path = "#{self.output_dir}/#{SecureRandom.uuid}#{File.extname(location)}"
      log("Download media [#{media.id}] from '#{location}' to '#{new_file_path}'")
      if media.origin_media_id.nil?
        raise "File not exists in location: '#{location}'" unless File.exist? location
        FileUtils.mkpath(File.dirname(new_file_path))
        FileUtils.cp(location, new_file_path)
      else
        raise "File not exists in location: '#{location}'" unless storage.file_exist? location
        storage.download location, new_file_path
      end
      raise "File was not downloaded to location: '#{new_file_path}'" unless File.exists? new_file_path
      output_files_array << new_file_path
    end
    log("Finish download medias with results: #{output_files_array.inspect}")
    self.result_files = output_files_array
  end

end
