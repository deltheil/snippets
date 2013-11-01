#!/usr/bin/env ruby
#
# Usage: WNC_CRED="email:pwd" ./index.rb mydatastore
#
require "winch"
require "batch"

ROOT_PATH = File.expand_path(File.dirname(__FILE__))
DATA_PATH = File.join(ROOT_PATH, "data")

NAMESPACES = {
  "cmds"   => ["application/json", ".json"],
  "docs"   => ["text/html", ".html"],
  "groups" => ["application/json", ".json"]
}

def say(msg)
  puts(msg) if (ENV["BATCH_INTERACTIVE"] || 1).to_i == 1
end

def search_datastore(c, name)
  c.list_datastores.find{|ds| ds.name == name}
end

def get_namespace(ds, name, prefix="rds:")
  ns = ds.search_namespace(prefix + name)
  ns = ds.create_namespace(prefix + name) if ns.nil?
  ns
end

if (cred = ENV["WNC_CRED"]).nil?
  STDERR.write("Please export WNC_CRED=\"email:pwd\"\n")
  exit(1)
end

C = Winch::Client.new(*cred.split(":"))

if ARGV[0].nil?
  STDERR.write("Usage: WNC_CRED=\"email:pwd\" ./import.rb mydatastore\n")
end

ds = search_datastore(C, ARGV[0])

NAMESPACES.each do |name, meta|
  ns = get_namespace(ds, name)
  say("Processing #{ns.name}")
  type, ext = meta
  files = Dir[File.join(DATA_PATH, name, "*#{ext}")]
  Batch.each(files) do |f|
    k, v = File.basename(f, ext), IO.read(f)
    rec = ns.search_record(k)
    if rec.nil?
      ns.create_record(k, v, type)
    else
      rec.update_value(v, type) if rec.get_value != v
    end
  end
end
