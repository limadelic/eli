# frozen_string_literal: true

require 'English'
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
end
