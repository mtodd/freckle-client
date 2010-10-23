require "rubygems"
require "bundler/setup"

require File.join(File.dirname(__FILE__), '..', 'lib', 'freckle')

require 'test/unit'
require 'fakeweb'
FakeWeb.allow_net_connect = false

{ "http://test.letsfreckle.com/api/users.json"    => "users",
  "http://test.letsfreckle.com/api/projects.json" => "projects",
  "http://test.letsfreckle.com/api/entries.json"  => "entries",
  "http://test.letsfreckle.com/api/entries.json?search[projects]=19618" => "entries_for_project",
  "http://test.letsfreckle.com/api/entries.json?search[people]=5538"    => "entries_for_user"
}.each do |(uri, fixture)|
  FakeWeb.register_uri(:get, uri, :body => File.read(File.join(File.dirname(__FILE__), "fixtures", "%s.json" % fixture)))
end
