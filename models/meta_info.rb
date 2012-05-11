class MetaInfo
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :media_id, :type => String
  embedded_in :media

  FIELDS = [
            :filename,
            :path,
            :full_filename,
            :valid?,
            :container,
            :raw_duration,
            :duration,
            :ratio,
            :bitrate,
            :bitrate_units,
            :bitrate_with_units,
            :audio_bit_rate,
            :audio_bit_rate_units,
            :audio_bit_rate_with_units,
            :audio_stream,
            :audio_codec,
            :audio_sample_rate,
            :audio_sample_rate_units,
            :audio_sample_units,
            :audio_sample_rate_with_units,
            :audio_channels_string,
            :audio_channels,
            :audio_sample_bit_depth,
            :audio_stream_id,
            :video_stream,
            :video_stream_id,
            :video_codec,
            :video_colorspace,
            :width,
            :height,
            :resolution,
            :video_orientation,
            :pixel_aspect_ratio,
            :display_aspect_ratio,
            :video_bit_rate,
            :video_bit_rate_units,
            :fps,
            :framerate,
            :time_base,
            :codec_time_base,
            :creation_time
          ]
end
