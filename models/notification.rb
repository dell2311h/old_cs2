class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :callback_url, :type => String, :default => ''
  field :status, :type => String, :default => 'not delivered'
  field :data, :type => Hash, :default => {}
  field :response, :type => String, :default => ''

  belongs_to :encoder

  after_create :add_to_queue

  def deliver
    request = Net::HTTP::Post.new(callback_url)
    url = URI.parse(URI.encode(callback_url))
    request.body = data.to_param
    response = Net::HTTP.new(url.host, url.port).start { |http|
      http.request(request)
    }
    self.response = response.body
    raise "Callback not accessible" unless response.code == '200'
    self.status = 'delivered'
  ensure
    save!
  end

  private

    def add_to_queue
      Resque.enqueue(Notifier, id)
    end
end
