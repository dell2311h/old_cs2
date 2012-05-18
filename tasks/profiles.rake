namespace :profiles do
  task :create_default => :environment do
    # Demux
    demux = Profile.create :name => "demux"
    audio_command = demux.commands.create :job_name => "audio_demux", :ordering_number => 0, :create_media => true
    audio_command.options.create :key => "destination", :params_key_name => "audio_destination"
    audio_command.options.create :key => "media_type", :value => "demuxed_audio"
    video_command = demux.commands.create :job_name => "video_demux", :ordering_number => 1, :create_media => true
    video_command.options.create :key => "destination", :params_key_name => "video_destination"
    video_command.options.create :key => "media_type", :value => "demuxed_video"

    # Meta info
    meta_info = Profile.create :name => "meta_info"
    meta_command = meta_info.commands.create :job_name => "meta_info", :ordering_number => 0, :update_media => true
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
    scale_command.options.create :key => "destination", :params_key_name => "destination"
    scale_command.options.create :key => "height", :params_key_name => "height"
    scale_command.options.create :key => "width", :params_key_name => "width"

    # Bitrate
    bitrate = Profile.create :name => "bitrate"
    bitrate_command = bitrate.commands.create :job_name => "bitrate", :ordering_number => 0, :create_media => true
    bitrate_command.options.create :key => "destination", :params_key_name => "destination"
    bitrate_command.options.create :key => "bitrate", :params_key_name => "bitrate"

    # Master track
    master_track = Profile.create :name => "master_track"
    audio_cut_command = master_track.commands.create :job_name => "audio_cut", :ordering_number => 0
    audio_cut_command.options.create :key => "cutting_timings", :params_key_name => "cutting_timings"
    audio_join_command = master_track.commands.create :job_name => "audio_join", :ordering_number => 1, :input_from_command_with_number => 0

    audio_normalize_command = master_track.commands.create :job_name => "audio_normalize", :ordering_number => 2, :input_from_command_with_number => 1

    audio_convert_command = master_track.commands.create :job_name => "audio_convert", :ordering_number => 3, :input_from_command_with_number => 2, :create_media => true
    audio_convert_command.options.create :key => "destination", :params_key_name => "destination"
    audio_convert_command.options.create :key => "media_type", :value => "master_track"
    audio_convert_command.options.create :key => "format", :value => "mp3"

    # Streaming
    streaming = Profile.create :name => "streaming"
    # Frame rate normalize
    streaming_command1 = streaming.commands.create :job_name => "frame_rate", :ordering_number => 0
    streaming_command1.options.create :key => "framerate", :value => 24, :params_key_name => "framerate"
    # Resize
    streaming_command2 = streaming.commands.create :job_name => "scale", :ordering_number => 1, :input_from_command_with_number => 0
    streaming_command2.options.create :key => "height", :value => 160
    streaming_command2.options.create :key => "width", :value => 240
    streaming_command3 = streaming.commands.create :job_name => "scale", :ordering_number => 2, :input_from_command_with_number => 0
    streaming_command3.options.create :key => "height", :value => 320
    streaming_command3.options.create :key => "width", :value => 480
    streaming_command4 = streaming.commands.create :job_name => "scale", :ordering_number => 3, :input_from_command_with_number => 0
    streaming_command4.options.create :key => "height", :value => 640
    streaming_command4.options.create :key => "width", :value => 960
    # Create media for first size with different bitrate
    streaming_command5 = streaming.commands.create :job_name => "bitrate", :ordering_number => 4, :input_from_command_with_number => 1, :create_media => true
    streaming_command5.options.create :key => "destination", :params_key_name => "destination_1"
    streaming_command5.options.create :key => "bitrate", :value => 100
    streaming_command5.options.create :key => "media_type", :value => "160x240_low"
    streaming_command6 = streaming.commands.create :job_name => "bitrate", :ordering_number => 5, :input_from_command_with_number => 1, :create_media => true
    streaming_command6.options.create :key => "destination", :params_key_name => "destination_2"
    streaming_command6.options.create :key => "bitrate", :value => 200
    streaming_command6.options.create :key => "media_type", :value => "160x240_normal"
    streaming_command7 = streaming.commands.create :job_name => "bitrate", :ordering_number => 6, :input_from_command_with_number => 1, :create_media => true
    streaming_command7.options.create :key => "destination", :params_key_name => "destination_3"
    streaming_command7.options.create :key => "bitrate", :value => 300
    streaming_command7.options.create :key => "media_type", :value => "160x240_high"
    # Create media for second size with different bitrate
    streaming_command8 = streaming.commands.create :job_name => "bitrate", :ordering_number => 7, :input_from_command_with_number => 2, :create_media => true
    streaming_command8.options.create :key => "destination", :params_key_name => "destination_4"
    streaming_command8.options.create :key => "bitrate", :value => 100
    streaming_command8.options.create :key => "media_type", :value => "320x480_low"
    streaming_command9 = streaming.commands.create :job_name => "bitrate", :ordering_number => 8, :input_from_command_with_number => 2, :create_media => true
    streaming_command9.options.create :key => "destination", :params_key_name => "destination_5"
    streaming_command9.options.create :key => "bitrate", :value => 200
    streaming_command9.options.create :key => "media_type", :value => "320x480_normal"
    streaming_command10 = streaming.commands.create :job_name => "bitrate", :ordering_number => 9, :input_from_command_with_number => 2, :create_media => true
    streaming_command10.options.create :key => "destination", :params_key_name => "destination_6"
    streaming_command10.options.create :key => "bitrate", :value => 300
    streaming_command10.options.create :key => "media_type", :value => "320x480_high"
    # Create media for third size with different bitrate
    streaming_command11 = streaming.commands.create :job_name => "bitrate", :ordering_number => 10, :input_from_command_with_number => 3, :create_media => true
    streaming_command11.options.create :key => "destination", :params_key_name => "destination_7"
    streaming_command11.options.create :key => "bitrate", :value => 100
    streaming_command11.options.create :key => "media_type", :value => "640x960_low"
    streaming_command12 = streaming.commands.create :job_name => "bitrate", :ordering_number => 11, :input_from_command_with_number => 3, :create_media => true
    streaming_command12.options.create :key => "destination", :params_key_name => "destination_8"
    streaming_command12.options.create :key => "bitrate", :value => 200
    streaming_command12.options.create :key => "media_type", :value => "640x960_normal"
    streaming_command13 = streaming.commands.create :job_name => "bitrate", :ordering_number => 12, :input_from_command_with_number => 3, :create_media => true
    streaming_command13.options.create :key => "destination", :params_key_name => "destination_9"
    streaming_command13.options.create :key => "bitrate", :value => 300
    streaming_command13.options.create :key => "media_type", :value => "640x960_high"
    # end streaming profile

  end
end

