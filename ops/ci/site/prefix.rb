#!/usr/bin/env ruby

require 'json'
require 'open3'
require 'uri'

module Prefix
  PROTECTED = %w[main badges]

  def self.run
    ARGV.first == 'prune' ? puts(prune(ENV)) : run_compute
  end

  def self.run_compute
    branch = ENV['BRANCH']
    return if branch.nil?

    puts compute(branch)
  end

  def self.prune(env)
    branch = env.fetch('DELETED_BRANCH', '')
    return [] if protected?(branch)

    stored(prune_name(branch, env))
  end

  def self.stored(name)
    File.directory?(name) ? ["#{name}/"] : []
  end

  def self.prune_name(branch, env)
    branch.empty? ? env.fetch('PR_NUMBER') : slug(branch)
  end

  def self.protected?(branch)
    PROTECTED.include?(branch)
  end

  def self.compute(branch)
    return '' if main_or_test?(branch)

    "#{pr_or_branch(branch)}/"
  end

  def self.pr_or_branch(branch)
    event_pr_number || branch_pr(branch)
  end

  def self.event_pr_number
    number = ENV.fetch('PR_NUMBER', '')
    number unless number.empty?
  end

  def self.branch_pr(branch)
    fetch_pr(branch) || slug(branch)
  end

  def self.slug(branch)
    branch.tr('/', '-')
  end

  def self.main_or_test?(branch)
    branch == 'main' || branch == 'test'
  end

  def self.fetch_pr(branch)
    pulls(branch).map { |pr| pr['number'].to_s }.first
  end

  def self.pulls(branch)
    JSON.parse(gh(pulls_path(branch)))
  rescue JSON::ParserError
    abort 'prefix: gh api returned bad JSON'
  end

  def self.pulls_path(branch)
    repo = ENV.fetch('GITHUB_REPOSITORY')
    owner = repo.split('/').first
    query = URI.encode_www_form('state' => 'open', 'head' => "#{owner}:#{branch}", 'per_page' => 100)
    "repos/#{repo}/pulls?#{query}"
  end

  def self.gh(path)
    out, err, status = capture(path)
    abort "prefix: gh api #{path} failed: #{err.strip}" unless status.success?
    out
  end

  def self.capture(path)
    Open3.capture3('gh', 'api', path)
  rescue Errno::ENOENT
    abort 'prefix: gh not found on PATH'
  end
end

Prefix.run if __FILE__ == $PROGRAM_NAME
