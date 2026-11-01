# frozen_string_literal: true

When(/^> eli(?: (.+))?$/) do |args, *rest|
  output = run(args)
  expect_lines(rest.first, output)
end

When(/^> touch (.+)$/) do |path, body|
  file = File.join(home, '.claude', 'skills', path)
  FileUtils.mkdir_p(File.dirname(file))
  File.write(file, "#{body}\n")
end

When(/^> cd (.+)$/) do |path|
  @cwd = File.join(home, '.claude', 'skills', path)
end

FIXTURES = File.expand_path('../fixtures', __dir__)

Then(/^every fixture matches its markers$/) do
  fixtures = Dir[File.join(FIXTURES, '*.md')]
  expect(fixtures).not_to be_empty
  fixtures.each { |fixture| expect_markers(fixture) }
end

def expect_markers(fixture)
  rule = File.basename(fixture, '.md')
  copy_skill(fixture, rule)
  output = run(rule)
  hits = output.split("\n").grep(hit(rule))
  expect(output.split("\n") - hits).to be_empty, output
  expect(hits.map { |line| line[/:(\d+) /, 1].to_i - 1 }).to eq(marked(fixture, rule)), output
end

def copy_skill(fixture, rule)
  skill = File.join(home, '.claude', 'skills', rule)
  FileUtils.mkdir_p(skill)
  FileUtils.cp(fixture, File.join(skill, 'SKILL.md'))
end

def hit(rule)
  %r{^#{Regexp.escape(rule)}/SKILL\.md:\d+ #{Regexp.escape(rule)} }
end

def marked(fixture, rule)
  lines = File.readlines(fixture)
  lines.each_index.select { |index| lines[index].include?("{#{rule}}") }
end

def expect_lines(table, output)
  return expect(output).to be_empty unless table

  sight(table.raw.flatten, output)
end

def sight(cells, output)
  cells.reduce(0) { |cursor, cell| spot(cell, output, cursor) }
end

def spot(cell, output, cursor)
  idx = output.index(cell, cursor)
  raise "Expected '#{cell}' in output after #{cursor}:\n#{output}" unless idx

  idx + cell.length
end
