module Encoder
require 'uri'
require 'net/http'

  class Demux
    @queue = :encoding

    def self.perform(origin_media_id, type)
      media = Media.find(origin_media_id)
      clip = media.demux(type.to_sym)
      result = {
        :status => 'ok',
        :message => "Created demuxed #{type} from media ##{origin_media_id}",
        :origin_media_id => origin_media_id,
        :command => 'demux',
        :type => type,
        :clip => {
          :id => clip.id,
          :origin_media_id => clip.origin_media_id,
          :type => clip.type,
          :source => clip.source
          }
        }
      rescue Exception => e
        result = {
        :status => 'error',
        :message => e.message,
        :origin_media_id => origin_media_id,
        :command => 'demux',
        :type => type
        }
      ensure
        notification = Notification.create(:callback_url => "#{Pandrino.callback_url}/demux", :data => result)
        Resque.enqueue(Notifier::Send, notification.id)
    end
  end
end