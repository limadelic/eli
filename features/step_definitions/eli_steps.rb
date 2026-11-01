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

When(/^> run (.+)$/) do |args|
  @output = run(args)
end

When(/^> sample \.eli\.yml from the README$/) do
  file = File.join(home, '.claude', 'skills', '.eli.yml')
  FileUtils.mkdir_p(File.dirname(file))
  File.write(file, readme_sample)
end

Then(/^the output is exactly$/) do |table|
  expect(@output.lines(chomp: true)).to eq(table.raw.flatten)
end

Then(/^the output is empty$/) do
  expect(@output).to be_empty
end

Then(/^the exit code is (\d+)$/) do |code|
  expect(@status.exitstatus).to eq(code.to_i)
end

def readme_sample
  readme = File.expand_path('../../README.md', __dir__)
  File.read(readme)[/^```ya?ml\n(.*?)^```/m, 1] || raise('no yaml block in README')
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
