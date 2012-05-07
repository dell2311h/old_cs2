class Media
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :location,        :type => String, :default => ''
  field :origin_media_id, :type => String, :default => ''
  field :type,            :type => String, :default => 'origin'

  has_many :encoding_medias, :class_name => 'Media', :inverse_of => :origin_media
  belongs_to :origin_media, :class_name => 'Media', :inverse_of => :encoding_media
  embeds_one :meta_info

  #after_create :add_meta_info

  def demux(type)
    type == :video ? (key, ext = 'a','.mov') : (key, ext = 'v','.wav')
    transcoder = RVideo::Transcoder.new(self.source)
    recipe = "ffmpeg -i $input_file$ -vcodec copy -#{key}n -y $output_file$"
    params = { :output_file => "#{Pandrino.encoded_media_path}/demuxed/#{type}/#{File.basename(self.source,'.MOV')}#{ext}" }
    transcoder.execute(recipe, params)
    encoding = self.encoding_medias.find_or_create_by(:command => 'demux', :type => type)
    encoding.source = params[:output_file]
    encoding.save
    encoding
    rescue Exception => e
      puts "Unable to transcode file: #{e.class} - #{e.message}"
  end

private

  def add_meta_info
    file = RVideo::Inspector.new(:file => self.location)
    meta_info = self.build_meta_info
    MetaInfo::FIELDS.each do |field|
      meta_info[field] = file.send(field)
    end
    meta_info.save
  end

end
