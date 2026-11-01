#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'

module Check
  BASE = 'https://limadelic.github.io/eli'
  REPO = 'limadelic/eli'
  TRIES = Integer(ENV.fetch('TRIES', 10))
  GAP = Float(ENV.fetch('GAP', 15))

  def self.run
    bad = failures
    bad.each { |url| puts url }
    exit status(bad)
  end

  def self.status(bad)
    bad.empty? ? 0 : 1
  end

  def self.failures
    unsettled.map(&:first)
  end

  def self.unsettled
    checks.reject { |_url, check| settle(check) }
  end

  def self.settle(check)
    TRIES.times.any? { attempt(check) }
  end

  def self.attempt(check)
    check.call || pause
  end

  def self.pause
    sleep GAP
    false
  end

  def self.checks
    dirs.flat_map { |dir| page_checks(dir) } + pr_checks + readme_checks
  end

  def self.dirs
    prs = open_prs
    branches.map { |branch| prefix(branch, prs) }.unshift('')
  end

  def self.prefix(branch, prs)
    "#{prs.fetch(branch, branch)}/"
  end

  def self.branches
    names.reject { |name| name == 'main' }
  end

  def self.names
    `git ls-remote --heads origin`.split("\n").map { |line| line.split('refs/heads/').last }
  end

  def self.open_prs
    listing = `gh pr list -R #{REPO} --state open --json number,headRefName`
    JSON.parse(listing).to_h { |pr| [pr['headRefName'], pr['number']] }
  end

  def self.page_checks(dir)
    cukes = "#{BASE}/#{dir}cukes.json"
    report = "#{BASE}/#{dir}report.html"
    shield = badge(cukes)
    [
      [cukes, -> { get(cukes).code == '200' }],
      [report, -> { get(report).code == '200' }],
      [shield, -> { badge_ok?(shield) }]
    ]
  end

  def self.badge(cukes)
    "https://img.shields.io/endpoint?url=#{URI.encode_www_form_component(cukes)}"
  end

  def self.badge_ok?(url)
    res = get(url)
    res.code == '200' && svg?(res.body)
  end

  def self.svg?(text)
    text.include?('cukes') && text.match?(%r{\d+/\d+})
  end

  def self.pr_checks
    open_prs.values.flat_map { |number| body_checks(number) }
  end

  def self.body_checks(number)
    camo_checks("PR #{number} body has camo image", camo_srcs(number))
  end

  def self.camo_checks(label, srcs)
    [[label, -> { srcs.any? }]] + srcs.map { |src| [src, -> { camo_ok?(src) }] }
  end

  def self.camo_srcs(number)
    body = `gh api repos/#{REPO}/pulls/#{number} -H "Accept: application/vnd.github.html+json" --jq .body_html`
    scan(body)
  end

  def self.scan(html)
    html.scan(%r{src="(https://camo\.githubusercontent\.com/[^"]+)"}).flatten
  end

  def self.readme_checks
    camo_checks('README has camo image', readme_srcs)
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
    res.code == '200' && res['content-type'].to_s.start_with?('image/svg+xml')
  end

  def self.get(url)
    Net::HTTP.get_response(URI(url))
  end
end

Check.run
