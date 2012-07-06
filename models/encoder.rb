class Encoder
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :params,           :type => Hash
  field :input_media_ids,  :type => Array
  field :result_media_ids, :type => Array
  field :attempts,         :type => Integer, :default => 0
  field :conveyor_errors,  :type => Array,   :default => []
  field :callback_url,     :type => String,  :default => ''
  belongs_to :profile
  has_many :notifications

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  def retry_encoding_which_was_interrupted_by(error)
    self.conveyor_errors << { occured_at: Time.now, description: error.message }
    self.update_attribute(:attempts, self.attempts + 1)
    if self.attempts < Pandrino.encoding_max_attempts
      Resque.enqueue(Conveyor, self.id)
    else
      raise error
    end
  end

end
