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

  def log(message, severity = :info)
    logfile = File.join(Padrino.root, '/log/', "conveyor.log")
    @log ||= ActiveSupport::BufferedLogger.new(logfile)
    @log.send severity, "[#{Time.now.to_s(:db)}] [#{severity.to_s.capitalize}] #{message}\n"
  end

end
