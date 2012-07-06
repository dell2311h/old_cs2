class Job::MetaInfo < Job::Processing

  def perform
    media = Media.find(options[:media_id])
    raise "Media with ID##{options['media_id']} not found." if media.nil?
    file = MiniExiftool.new(self.input_files_array[0])
    meta_info = media.build_meta_info
    MetaInfo::FIELDS.each do |field|
      meta_info[field] = file.send(field)
    end
    meta_info.save
    log("Get meta_info for video '#{self.input_files_array[0]}'")
    log("MEta Info: #{meta_info.inspect}")
    self.result_files = [self.input_files_array[0]]
  end

  def update_media(server_type)
    Media.find(options[:media_id])
  end

end
