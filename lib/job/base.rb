class Job::Base

  attr :options
  attr_accessor :result_files

  def initialize options = {}
    raise "Can't initialize an abstract class instance" if self.class == Job::Base
    @options = options
    @result_files = []
  end

  def perform
    raise 'Not inmplemeted'
  end

end

