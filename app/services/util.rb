class Util

  def self.cmd(command)
    output = `#{command}`
    if $? != 0
      raise RuntimeError.new("Command [#{command}] did not run successfully with exit code: #{$?}\n#{output}")
    end
    return output
  end

end