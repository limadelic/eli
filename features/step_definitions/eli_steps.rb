# frozen_string_literal: true

When(/^> eli(?: (.+))?$/) do |args, *rest|
  expect_lines(rest.first, run(args))
end

When(/^> touch (.+)$/) do |path, body|
  file = File.join(home, '.claude', 'skills', path)
  FileUtils.mkdir_p(File.dirname(file))
  File.write(file, "#{body}\n")
end

When(/^> cd (.+)$/) do |path|
  @cwd = File.join(home, '.claude', 'skills', path)
end

When(/^> sample \.eli\.yml from the README$/) do
  file = File.join(home, '.claude', 'skills', '.eli.yml')
  FileUtils.mkdir_p(File.dirname(file))
  File.write(file, readme_sample)
end

def readme_sample
  readme = File.expand_path('../../README.md', __dir__)
  File.read(readme)[/^```ya?ml\n(.*?)^```/m, 1] || raise('no yaml block in README')
end

def expect_lines(doc, output)
  wants = doc.to_s.lines(chomp: true)
  return expect(output).to be_empty if wants.empty?

  ordered(wants, output.lines(chomp: true))
end

def ordered(wants, lines)
  wants.inject(lines, &method(:after))
end

def after(lines, want)
  idx = position(lines, want)
  raise "Expected '#{want}' in output:\n#{lines.join("\n")}" unless idx

  lines.drop(idx + 1)
end

def position(lines, want)
  lines.index { |line| line.include?(want) }
end
