#!/usr/bin/env ruby

require 'json'
require 'fileutils'
require_relative '../site/prefix'

module Badges
  def self.run
    pref = Prefix.compute(branch)
    FileUtils.mkdir_p("site/#{pref}")
    report(pref, scenarios)
  end

  def self.branch
    ENV['BRANCH'].sub(%r{/merge$}, '')
  end

  def self.scenarios
    fetch('reports/cucumber.json').flat_map { |f| f.fetch('elements', []) }
  end

  def self.fetch(path)
    JSON.parse(File.read(path))
  rescue JSON::ParserError, Errno::ENOENT
    []
  end

  def self.report(pref, scenarios)
    msg, color = outcome(passed(scenarios), scenarios.length)
    File.write("site/#{pref}cukes.json", JSON.generate(badge('cukes', msg, color, 'cucumber')))
  end

  def self.passed(scenarios)
    scenarios.count { |sc| ok?(sc) }
  end

  def self.ok?(scenario)
    scenario.fetch('steps', []).all? { |s| s.dig('result', 'status') == 'passed' }
  end

  def self.badge(label, message, color, logo)
    {
      schemaVersion: 1,
      label: label,
      message: message,
      color: color,
      labelColor: '173647',
      namedLogo: logo,
      logoColor: 'white'
    }
  end

  def self.outcome(n, total)
    ["#{n}/#{total}", color(n == total && total.positive?)]
  end

  def self.color(ok)
    ok ? '23D96C' : 'e05d44'
  end
end

Badges.run
