# frozen_string_literal: true

require 'open3'

module Home
  def run(args)
    Open3.capture2e({ 'HOME' => home }, "eli #{args}", chdir: workdir).first
  end

  def home
    @home
  end

  def workdir
    @cwd || File.join(home, '.claude', 'skills')
  end
end
