# frozen_string_literal: true

require 'open3'

module Home
  def run(args)
    output, = Open3.capture2e({ 'HOME' => home }, "eli #{args}", chdir: @cwd || home)
    output
  end

  def home
    @home
  end
end
