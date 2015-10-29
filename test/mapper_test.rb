require 'ostruct'
require './test/test_helper'

User, Page, List, Item = [OpenStruct] * 4

class UserMapper < Bagatelle::Mapper
  children :pages, lists: :items
  def find(id)
    recursive_map('users', 'id', [id], associations)
  end
end

class TestMapper < Minitest::Test

  def test_mapper
    um = UserMapper.new(Bagatelle::MysqlStorage.new(:host => "localhost", :username => "root", :database => "site_development"))
    user = um.find(1).first
    assert_equal 'Sam', user.name
    assert_equal 'Home', user.pages.first.name
    assert_equal 'To Do', user.lists.first.name
    assert_equal 'Mow Lawn', user.lists.first.items.first.name
  end

  def test_local
    um = UserMapper.new(Bagatelle::LocalStorage.new({'users' => users, 'pages' => [], 'lists' => [], 'items' => []}))
    user = um.find(1).first
    assert_equal 'Sam', user.name
  end

  def users
    [
      {
        'id' => 0,
        'name' => 'Julie'
      },
      {
        'id' => 1,
        'name' => 'Sam',
      }
    ]
  end
end
