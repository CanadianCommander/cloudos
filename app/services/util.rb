require 'open3'

class Util
  DEFAULT_COMMAND_TIMEOUT = '60m'

  def self.cmd(*commands)
    stdout, stderr, status = Open3.capture3("timeout", DEFAULT_COMMAND_TIMEOUT, *commands)

    if status.exitstatus == 124
      raise RuntimeError.new("Command [#{commands.to_s}] timeout out")
    elsif status.exitstatus != 0
      raise RuntimeError.new("Command [#{commands.to_s}] did not run successfully with exit code: #{$?}\n#{stdout + stderr}")
    end
    return stdout
  end

end