class Media
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :source, :type => String, :default => ''
  field :origin_media_id, :type => String, :default => ''

  has_many :encoding_medias, :class_name => 'Media', :inverse_of => :origin_media
  belongs_to :origin_media, :class_name => 'Media', :inverse_of => :encoding_media

  embeds_one :meta_info
  after_create :add_meta_info

private

  def add_meta_info
    file = RVideo::Inspector.new(:file => self.source)
    meta_info = self.build_meta_info
    MetaInfo::FIELDS.each do |field|
      meta_info[field] = file.send(field)
    end
    meta_info.save
  end

end
