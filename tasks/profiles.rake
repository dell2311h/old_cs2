namespace :profiles do
  task :create_default => :environment do
    # Demux
    demux = Profile.create :name => "demux"
    demux.commands.create :job_name => "audio_demux", :ordering_number => 0, :create_media => true
    demux.commands.create :job_name => "video_demux", :ordering_number => 1, :create_media => true

    # Meta info
    meta_info = Profile.create :name => "meta_info"
    meta_command = meta_info.commands.create :job_name => "meta_info", :ordering_number => 0
    meta_command.options.create :key => "media_id", :params_key_name => "media_id"

    # Rotate
    rotate = Profile.create :name => "rotate"
    rotate_command = rotate.commands.create :job_name => "rotate", :ordering_number => 0, :update_media => true
    rotate_command.options.create :key => "media_id", :params_key_name => "media_id"
    rotate_command.options.create :key => "angle", :params_key_name => "angle"
  end
end
