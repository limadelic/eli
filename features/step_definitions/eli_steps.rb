# frozen_string_literal: true

When(/^> eli(?: (.+))?$/) do |args, *rest|
  output = run(args)
  expect_lines(rest.first, output)
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
