require 'uri'
require 'net/http'

class Notifier

  @queue = :notifications

  def self.perform(id)
    notification = Notification.find(id)
    notification.deliver
  end
end