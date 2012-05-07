class Command
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :ordering_number, :type => Integer
  field :job_name, :type => String
  field :input_from_command_with_number, :type => Integer, :default => nil
  field :create_media, :type => Boolean, :default => :false
  embeds_many :options
  embedded_in :profile

  validates_uniqueness_of :ordering_number

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end

