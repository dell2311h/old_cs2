class Media
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  field :source, :type => String, :default => ''
  field :parent_id, :type => String, :default => ''
  # field <name>, :type => <type>, :default => <value>

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

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
