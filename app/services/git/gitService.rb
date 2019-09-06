require 'singleton'

class Git::GitService
  include Singleton

  def valid_git_url?(git_url)
    begin
      Util.cmd("git", "ls-remote", "-h", git_url)
      return true
    rescue RuntimeError => e
      return false
    end
  end


  def clone(git_url, target_dir)
    Util.cmd("git", "clone", git_url, target_dir)
  end


end