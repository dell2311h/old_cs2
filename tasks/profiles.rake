namespace :profiles do
  task :create_default => :environment do
    demux = Profile.create :name => "demux"
    demux.commands.create :job_name => "audio_demux", :ordering_number => 0, :create_media => true
    demux.commands.create :job_name => "video_demux", :ordering_number => 1, :create_media => true

    meta_info = Profile.create :name => "meta_info"
    command = meta_info.commands.create :job_name => "meta_info", :ordering_number => 0
    command.options.create :key => "media_id", :params_key_name => "media_id"
  end
end
