namespace :profiles do
  task :create_default => :environment do
    demux = Profile.create :name => "demux"
    demux.commands.create :job_name => "audio_demux", :ordering_number => 0, :create_media => true
    demux.commands.create :job_name => "video_demux", :ordering_number => 1, :create_media => true

    #command = profile.commands.create :job_name => "scale", :ordering_number => 1, :input_from_command_with_number => 0
    #option = command.options.create :key => "resolution", :params_key_name => "resolution", :value => "640x480"
    #command = profile.commands.create :job_name => "rotate", :ordering_number => 2, :input_from_command_with_number => 1
    #option = command.options.create :key => "angle", :value => "90"
    #option = command.options.create :key => "direction", :value => "left", :params_key_name => "direction"
  end
end
