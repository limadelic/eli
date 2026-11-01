#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'
require_relative '../site/prefix'

module Check
  BASE = 'https://limadelic.github.io/eli'
  REPO = 'limadelic/eli'
  TRIES = Integer(ENV.fetch('TRIES', 10))
  GAP = Float(ENV.fetch('GAP', 15))
  ENV['GITHUB_REPOSITORY'] ||= REPO

  class CallFailed < StandardError; end

  def self.run
    bad = failures
    bad.each { |url| puts url }
    exit status(bad)
  end

  def self.status(bad)
    bad.empty? ? 0 : 1
  end

  def self.failures
    sources = camo_sources
    statics(sources) + unsettled(sources) + stale_messages
  rescue JSON::ParserError, KeyError, CallFailed
    ['gh call failed']
  end

  def self.stale_messages
    stale_dirs.map { |dir| "stale badges dir: #{dir}/" }
  end

  def self.stale_dirs
    live = open_numbers + live_branches
    stored_dirs.reject { |dir| live.include?(dir) }
  end

  def self.open_numbers
    open_prs.values.map(&:to_s)
  end

  def self.live_branches
    names = `gh api repos/#{REPO}/branches --paginate --jq '.[].name'`
    raise CallFailed unless $?.success?

    names.split("\n")
  end

  def self.stored_dirs
    trees.map { |entry| entry['path'] }
  end

  def self.trees
    tree_entries.select { |entry| entry['type'] == 'tree' }
  end

  def self.tree_entries
    JSON.parse(`gh api "repos/#{REPO}/git/trees/badges"`).fetch('tree')
  end

  def self.statics(sources)
    sources.to_h.select { |_label, srcs| srcs.empty? }.keys
  end

  def self.unsettled(sources)
    checks(sources).to_h.reject { |_url, check| settle(check) }.keys
  end

  def self.settle(check)
    check.call || retry_later(check)
  end

  def self.retry_later(check)
    (TRIES - 1).times.any? do
      sleep GAP
      check.call
    end
  end

  def self.checks(sources)
    dirs.flat_map { |dir| page_checks(dir) } + camo_checks(sources)
  end

  def self.dirs
    prs = open_prs
    ['', *prs.values.map { |number| "#{number}/" }, *current].uniq
  end

  def self.current
    branch = ref
    return [] if branch.nil?

    [Prefix.compute(branch)]
  end

  def self.open_prs
    listing = `gh pr list -R #{REPO} --state open --limit 1000 --json number,headRefName`
    JSON.parse(listing).to_h { |pr| [pr['headRefName'], pr['number']] }
  end

  def self.page_checks(dir)
    cukes = "#{BASE}/#{dir}cukes.json"
    report = "#{BASE}/#{dir}report.html"
    shield = badge(cukes)
    [
      [cukes, -> { status_ok?(get(cukes)) }],
      [report, -> { status_ok?(get(report)) }],
      [shield, -> { badge_ok?(shield) }]
    ]
  end

  def self.badge(cukes)
    "https://img.shields.io/endpoint?url=#{URI.encode_www_form_component(cukes)}"
  end

  def self.badge_ok?(url)
    res = get(url)
    status_ok?(res) && svg?(res.body)
  end

  def self.svg?(text)
    text.include?('cukes') && text.match?(%r{\d+/\d+})
  end

  def self.camo_sources
    pr_sources = open_prs.values.map { |number| ["PR #{number} body has camo image", camo_srcs(number)] }
    pr_sources + [['README has camo image', readme_srcs]]
  end

  def self.camo_checks(sources)
    camo_urls(sources).map { |src| [src, -> { camo_ok?(src) }] }
  end

  def self.camo_urls(sources)
    sources.flat_map { |_label, srcs| srcs }
  end

  def self.camo_srcs(number)
    body = `gh api repos/#{REPO}/pulls/#{number} -H "Accept: application/vnd.github.html+json" --jq .body_html`
    scan(body)
  end

  def self.scan(html)
    html.scan(%r{src="(https://camo\.githubusercontent\.com/[^"]+)"}).flatten
  end

  def self.readme_srcs
    html = `gh api "repos/#{REPO}/readme?ref=#{ref}" -H "Accept: application/vnd.github.html+json"`
    scan(html)
  end

  def self.ref
    [ENV['GITHUB_HEAD_REF'], ENV['GITHUB_REF_NAME']].find { |name| !name.to_s.empty? }
  end

  def self.camo_ok?(url)
    res = get(url)
    status_ok?(res) && res['content-type'].to_s.start_with?('image/svg+xml')
  end

  def self.status_ok?(res)
    res&.code == '200'
  end

  def self.get(url)
    Net::HTTP.get_response(URI(url))
  rescue StandardError
    nil
  end
end

Check.run
