require 'test_helper'

class FreckleTest < Test::Unit::TestCase
  
  def setup
    @logger = Logger.new(File.join(File.dirname(__FILE__), 'test.log'))
    @connection = Freckle.new(:account  => @account = "test",
                              :token    => @token   = "test",
                              :logger   => @logger)
  end
  
  def teardown
    Freckle.send(:instance_variable_set, :@connection, nil)
  end
  
  ### Query Methods
  
  def test_users
    assert !@connection.users.empty?
  end
  
  def test_projects
    assert !@connection.projects.empty?
  end
  
  def test_entries
    assert !@connection.entries.empty?
  end
  
  def test_user_by_login
    assert_equal nil, @connection.user_by_login('nonexistentuser')
    
    user = @connection.users.first
    assert_equal user, @connection.user_by_login(user.login)
  end
  
  ### Models
  
  def test_users_return_user_model
    assert user = @connection.users.first
    assert user.is_a?(Freckle::User)
  end
  
  def test_projects_return_project_model
    assert project = @connection.projects.first
    assert project.is_a?(Freckle::Project)
  end
  
  def test_entries_return_entry_model
    assert entry = @connection.entries.first
    assert entry.is_a?(Freckle::Entry)
  end
  
  def test_user_model_attributes_are_available_as_methods
    assert user = @connection.users.first
    assert_equal user.id,         user.attributes['id']
    assert_equal user.first_name, user.attributes['first_name']
    assert_equal user.last_name,  user.attributes['last_name']
  end
  
  ### Associations
  
  def test_user_model_can_query_for_its_entries
    assert user = @connection.users.first
    user.entries.each do |entry|
      assert_equal user, entry.user
    end
  end
  
  def test_project_model_can_query_for_its_entries
    assert project = @connection.projects.first
    project.entries.each do |entry|
      assert_equal project, entry.project
    end
  end
  
  ### Filtering
  
  def test_entries_can_filter_by_user
    assert user     = @connection.users.first
    assert project  = @connection.projects.first
    @connection.entries(:people => [user.id]).each do |entry|
      assert_equal user, entry.user
    end
  end
  
  ### Singleton Connection
  
  def test_user_all_without_established_connection_raises_error
    assert_raise RuntimeError, /establish_connection/ do
      Freckle::User.all
    end
  end
  
  def test_user_all_matches_users
    Freckle.establish_connection(:account => @account, :token => @token, :logger => @logger)
    assert_equal @connection.users, Freckle::User.all
  end
  
  def test_user_first_matches_first_user
    Freckle.establish_connection(:account => @account, :token => @token, :logger => @logger)
    assert_equal @connection.users.first, Freckle::User.first
  end
  
end
