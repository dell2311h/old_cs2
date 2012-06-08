class Job::AudioNormalize < Job::Processing

  def perform

   result_files = []
   raise "Empty input files" if (self.input_files_array.nil? || self.input_files_array.empty?)

   self.input_files_array.each do |file|
     out_file = "#{self.output_dir}/#{SecureRandom.uuid}.wav"
     FileUtils.cp(file, out_file)
     result_files.push out_file
   end

   recipe = "normalize-audio " + result_files.join(" ")
   raise 'Failed to normalize files' unless system recipe
   log("Normalize audio for #{self.input_files_array.join(", ")} and save to #{result_files.join(", ")}")
   self.result_files = result_files
  end

  def media_type
    'audio'
  end

end
