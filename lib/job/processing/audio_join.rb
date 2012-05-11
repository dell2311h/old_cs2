class Job::AudioJoin < Job::Processing

  def perform
   out_file = "#{self.output_dir}/#{SecureRandom.uuid}.wav"
   raise "Empty input files" if (self.input_files_array.nil? || self.input_files_array.empty?)
   files =  self.input_files_array.join(" ")

   recipe = "sox " + files + " " + out_file
   raise 'Failed to join files' unless system recipe

   self.result_files = [out_file]
  end

  def media_type
    'audio'
  end

end

