# Log time and log level.
# Monkey patch. Sorry.

class Logger::SimpleFormatter
  # This method is invoked when a log event occurs
  def call(severity, timestamp, progname, msg)
    msg = "#{String === msg ? msg : msg.inspect}"
    "[#{timestamp.to_s(:log)}] #{"%5s"% severity.upcase} #{msg}\n"
  end
end
