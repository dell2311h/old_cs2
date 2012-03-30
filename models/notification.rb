class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :callback_url, :type => String, :default => ''
  field :status, :type => String, :default => 'not delivered'
  field :data, :type => Hash, :default => {}
  field :response, :type => String, :default => ''

  def deliver
    request = Net::HTTP::Post.new(callback_url)
    url = URI.parse(URI.encode(callback_url))
    request.body = data.to_json
    request.add_field "Content-Type", "application/json"
    response = Net::HTTP.new(url.host, url.port).start { |http|
      http.request(request)
    }
    self.response = response.body
    self.status = 'delivered'
    save!
  end

end
