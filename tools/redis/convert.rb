#!/usr/bin/env ruby
ROOT_PATH = File.expand_path(File.dirname(__FILE__))
REDIS_IO  = File.expand_path("redis-io", ROOT_PATH)
REDIS_DOC = File.expand_path("redis-doc", ROOT_PATH)

require "redcarpet"
require "batch"
require "json"
require "cgi" # for HTML escaping
require "fileutils"
require File.join(REDIS_IO, "lib", "reference.rb")

COMMANDS = Reference.new(
  JSON.parse(IO.read(File.join(REDIS_DOC, "commands.json")))
)

RENDERER_OPTS = {
  no_links: true,
  no_styles: true
}

EXTENSIONS = {
  fenced_code_blocks: true
}

OUTPUT = {
  groups: File.join("data", "groups"),
  cmds:   File.join("data", "cmds"),
  docs:   File.join("data", "docs")
}

# Custom Reference extensions (see redis-io/lib/reference.rb)
class Reference
  class Group
    attr_accessor :index, :name, :cmds

    def initialize(index, name, cmds)
      @index, @name, @cmds = index, name, cmds
    end

    def uid
      "%03d" % (@index + 1)
    end

    def to_hash
      {name: name, cmds: cmds}
    end

    def to_s
      "#{uid}, #{name}, #{cmds}"
    end
  end

  class Command
    attr_accessor :cli

    def args
      arguments.join(" ")
    end

    def uid
      name.downcase
    end

    def to_hash
      h = {name: name, summary: command["summary"]}
      h[:cli] = cli unless cli.nil?
      h[:args] = args unless args.empty?
      h
    end
  end

  def commands_for(group)
    self.select{|c| c.group == group}.collect{|c| c.uid}.sort
  end

  def groups
    GROUPS.each_with_index.map{|x,i| Group.new(i, x[1], commands_for(x[0]))}
  end
end # Reference

# Custom Redcarpet renderer (see redis-io/lib/template.rb)
class SnippetsRender < Redcarpet::Render::HTML
  SECTIONS = {
    "description" => "Description",
    "examples"    => "Examples",
    "return"      => "Return value",
    "history"     => "History"
  }

  # See http://redis.io/topics/protocol
  REPLY_TYPES = {
    "nil"           => "Null reply",
    "simple-string" => "Simple string reply",
    "integer"       => "Integer reply",
    "bulk-string"   => "Bulk string reply",
    "array"         => "Array reply"
  }

  attr_reader :cmd

  def initialize(cmd, opts)
    super(opts)
    @cmd = cmd
  end

  def prologue
    p  = "<header>"
    p += "<h1>#{@cmd.name}"
    p += " <span>#{@cmd.args}</span>" unless @cmd.args.empty?
    p += "</h1>"
    p += "</header>"
    p += "<h2>"
    p += "Available since #{@cmd.since}"
    unless @cmd.complexity.nil?
      p += "<br/>"
      p += "Time complexity: #{@cmd.complexity}"
    end
    p += "</h2>"
    p
  end

  def cli(code)
    return nil if code =~ /redis>/
    code.split("\n")
  end

  def sections(source)
    source.gsub(/^\@(\w+)$/) do
      title = SECTIONS[$1]
      "## #{title}\n"
    end
  end

  def reply_types(source)
    source.gsub(/@(#{REPLY_TYPES.keys.join("|")})\-reply/) do
      type = $1
      REPLY_TYPES[type]
    end
  end

  # -- start of custom Redcarpet methods
  def block_code(code, language)
    # Keep the first example (if any)
    @cmd.cli ||= cli(code) if @header == "Examples"
    "<pre><code>%s</code></pre>" % CGI.escapeHTML(code)
  end

  def header(title, level)
    @header = title
    level += 1
    "<h#{level}>#{title}</h#{level}>"
  end

  def preprocess(data)
    data = sections(data)
    data = reply_types(data)
    data
  end

  def postprocess(data)
    "#{prologue}#{data}"
  end
end # SnippetsRender

def to_cmd(filename)
  File.basename(filename, ".md").upcase
end

def save_group(g)
  File.open(File.join(OUTPUT[:groups], "#{g.uid}.json"), "w") { |file|
    file << g.to_hash.to_json
  }
end

def save_cmd(c)
  File.open(File.join(OUTPUT[:cmds], "#{c.uid}.json"), "w") { |file|
    file << c.to_hash.to_json
  }
end

def save_doc(c, html)
  File.open(File.join(OUTPUT[:docs], "#{c.uid}.html"), "w") { |file|
    file << html
  }
end

# Main
if __FILE__ == $0
  OUTPUT.each { |_,path| FileUtils.mkdir_p(path) }

  jobs = COMMANDS.groups + Dir[File.join(REDIS_DOC, "commands", "*.md")]

  Batch.each(jobs) do |arg|
    if arg.is_a?(Reference::Group)
      save_group(arg)
    else
      cmd = COMMANDS[to_cmd(arg)]
      renderer = SnippetsRender.new(cmd, RENDERER_OPTS)
      markdown = Redcarpet::Markdown.new(renderer, EXTENSIONS)
      html = markdown.render(IO.read(arg))
      save_cmd(cmd)
      save_doc(cmd, html)
    end
  end
end
