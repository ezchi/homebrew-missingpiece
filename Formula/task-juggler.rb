class TaskJunggler < Formula
  desc "The TaskJuggler Project Management Software"
  homepage "http://taskjuggler.org/"

  def install
    system "gem", "install", "taskjuggler", "--version", "3.6.0", "--install-dir", prefix
  end
end
