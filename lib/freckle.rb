# http://github.com/madrobby/freckle-apidocs

require 'logger'

require 'rest_client'
require 'json'

class Freckle
  def initialize(options = {})
    @account  = options.delete(:account)
    @token    = options.delete(:token)
    @logger   = options.delete(:logger) || Logger.new(STDOUT)
    RestClient.log = @logger
    @connection = RestClient::Resource.new( "http://#{@account}.letsfreckle.com/api",
                                            :headers => {"X-FreckleToken" => @token} )
  end
  
  def self.establish_connection(options)
    @connection = new(options)
  end
  def self.connection
    return @connection if @connection
    raise RuntimeError, "Freckle.establish_connection with :account and :token first"
  end
  
  ### Query Methods
  
  def users(options = {})
    Array(JSON.parse(@connection['/users.json'].get)).flatten.map do |user|
      User.new(user['user'], self)
    end
  end
  
  def projects(options = {})
    Array(JSON.parse(@connection['/projects.json'].get)).flatten.map do |project|
      Project.new(project['project'], self)
    end
  end
  
  # people: comma separated user ids
  # projects: comma separated project ids
  # tags: comma separated tag ids
  # from: entries from this date
  # to: entries to this date
  # billable: true only shows billable entries; false only shows unbillable entries
  def entries(options = {})
    options.keys.each { |k| options["search[#{k}]"] = Array(options.delete(k)).flatten.join(',') }
    Array(JSON.parse(@connection['/entries.json'].get(:params => options))).flatten.map do |entry|
      Entry.new(entry['entry'], self)
    end
  end
  
  ### Models
  
  class Base
    include Comparable
    attr_reader :attributes
    def initialize(attributes, connection = nil)
      @connection = connection
      @attributes = attributes
    end
    def id
      @attributes['id']
    end
    def method_missing(method_name, *args)
      return @attributes[method_name.to_s] if @attributes.key?(method_name.to_s)
      super
    end
    def self.all(key = nil, options = {})
      raise ArgumentError, "key is required" if key.nil?
      Freckle.connection.send(key, options)
    end
    def self.first(options = {})
      self.all(options).first
    end
    def <=>(other)
      [self.class, self.id] <=> [other.class, other.id]
    end
  end
  
  class User < Base
    def self.all(options = {})
      super(:users, options)
    end
  end
  
  class Project < Base
    def self.all(options = {})
      super(:projects, options)
    end
    def entries(options = {})
      projects = (options.delete(:projects) || [])
      projects.push(self.id) unless projects.include?(self.id)
      @connection.entries(options.merge(:projects => projects))
    end
  end
  
  class Entry < Base
    def self.all(options = {})
      super(:entries, options)
    end
    def project(options = {})
      @connection.projects(options).detect{ |project| project.id == self.project_id }
    end
    def user(options = {})
      @connection.users(options).detect{ |user| user.id == self.user_id }
    end
  end
  
end
