module Notifier

  class Send
    @queue = :notifications

    def self.perform(id)
      notification = Notification.find(id)
      notification.deliver
    end
  end
end