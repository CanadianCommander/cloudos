require 'open3'
require 'timeout'

class Util
  DEFAULT_COMMAND_TIMEOUT = 60*60 # 60m

  def self.cmd(*commands)
    cmd_timeout(DEFAULT_COMMAND_TIMEOUT, *commands)
  end

  def self.cmd_timeout(timeout, *commands)
    Timeout.timeout(timeout) {
      stdout, stderr, status = Open3.capture3(*commands)

      if status.exitstatus != 0
        raise RuntimeError.new("Command [#{commands.to_s}] did not run successfully with exit code: #{$?}\n#{stdout + stderr}")
      end
      return stdout
    }
  end

end