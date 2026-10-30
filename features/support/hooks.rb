# frozen_string_literal: true

require 'English'
require 'fileutils'
require 'tmpdir'
require_relative 'home'
require_relative 'nest'

module Hooks
end

World(Home)

BeforeAll do
  Nest.nest
end

Before do
  @home = Dir.mktmpdir
  FileUtils.cp_r(File.expand_path('../home/.claude', __dir__), @home)
end
