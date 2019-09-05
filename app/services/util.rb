require 'open3'

class Util

  def self.cmd(*commands)
    stdout, stderr, status = Open3.capture3(*commands)
    if status.exitstatus != 0
      raise RuntimeError.new("Command [#{commands.to_s}] did not run successfully with exit code: #{$?}\n#{stdout + stderr}")
    end
    return stdout
  end

end