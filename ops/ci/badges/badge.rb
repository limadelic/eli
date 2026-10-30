module Badge
  def self.append(content)
    content + block
  end

  def self.block
    "<!-- badges-start -->\n#{cukes}\n<!-- badges-end -->\n"
  end

  def self.cukes
    base = "https://limadelic.github.io/eli/#{ENV.fetch('PREFIX')}"
    "[![cukes](https://img.shields.io/endpoint?url=#{base}cukes.json)](#{base}report.html)"
  end
end
