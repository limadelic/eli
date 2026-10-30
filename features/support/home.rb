# frozen_string_literal: true

require 'open3'

module Home
  def run(args)
    output, = Open3.capture2e({ 'HOME' => home }, "eli #{args}")
    output
  end

  def home
    File.expand_path('../home', __dir__)
  end
end
