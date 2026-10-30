# frozen_string_literal: true

require 'fileutils'

module Nest
  ROOT = File.expand_path('../..', __dir__)
  TMP = File.join(ROOT, 'tmp')
  PREFIX = File.join(TMP, 'eli')

  def self.nest
    FileUtils.mkdir_p(TMP)
    stage(pack)
    ENV['PATH'] = "#{File.join(PREFIX, 'bin')}:#{ENV.fetch('PATH')}"
  end

  def self.pack
    tgz = `cd #{ROOT} && npm pack --silent --pack-destination #{TMP}`.strip
    raise 'npm pack failed' unless $CHILD_STATUS.success?

    File.join(TMP, tgz)
  end

  def self.stage(tgz)
    system('npm', 'install', '-g', '--silent', '--prefix', PREFIX, tgz) || raise('npm install failed')
  end
end
