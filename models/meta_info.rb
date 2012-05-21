class MetaInfo
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :media_id, :type => String
  embedded_in :media

  FIELDS = [
            :mime_type,
            :file_type,
            :movie_data_size,
            :duration,
            :image_width,
            :image_height,
            :video_frame_rate,
            :create_date,
            :rotation,
            :gps_latitude,
            :gps_longitude,
            :gps_position
          ]
end
