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
      new_file_path = options[:destination]
      PANDRINO_STORAGE.upload file_path, new_file_path
      raise "File was not uploaded to location'#{new_file_path}'" unless PANDRINO_STORAGE.file_exist? new_file_path
      media = Media.create(:type => self.get_media_type, :location => new_file_path, :origin_media_id => origin_id)
      medias << media
      log("Create media #{media.id} with type: #{self.get_media_type}, location: #{new_file_path}, origin_media_id: #{origin_id}")
    end
    medias
  end

  def update_media
    media = Media.find(options[:media_id])
    PANDRINO_STORAGE.update self.result_files.first, media.location
    raise "File was not updated with location'#{media.location}'" unless PANDRINO_STORAGE.file_exist? media.location
    log("Update location media #{media.id} from #{self.result_files.first} to #{media.location}")
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
