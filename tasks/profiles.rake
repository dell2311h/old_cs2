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

    # Frame rate
    frame = Profile.create :name => "frame_rate"
    frame_command = frame.commands.create :job_name => "frame_rate", :ordering_number => 0, :update_media => true
    frame_command.options.create :key => "media_id", :params_key_name => "media_id"
    frame_command.options.create :key => "framerate", :params_key_name => "framerate"

    # Scale
    scale = Profile.create :name => "scale"
    scale_command = scale.commands.create :job_name => "scale", :ordering_number => 0, :create_media => true
    scale_command.options.create :key => "media_id", :params_key_name => "media_id"
    scale_command.options.create :key => "height", :params_key_name => "height"
    scale_command.options.create :key => "width", :params_key_name => "width"

    # Bitrate
    bitrate = Profile.create :name => "bitrate"
    bitrate_command = bitrate.commands.create :job_name => "bitrate", :ordering_number => 0, :create_media => true
    bitrate_command.options.create :key => "media_id", :params_key_name => "media_id"
    bitrate_command.options.create :key => "bitrate", :params_key_name => "bitrate"

    # Master track
    master_track = Profile.create :name => "master_track"
    audio_cut_command = master_track.commands.create :job_name => "audio_cut", :ordering_number => 0
    audio_cut_command.options.create :key => "cutting_timings", :params_key_name => "cutting_timings"
    audio_join_command = master_track.commands.create :job_name => "audio_join", :ordering_number => 1, :create_media => true
  end
end

