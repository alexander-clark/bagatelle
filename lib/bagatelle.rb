require 'bagatelle/version'
require 'mysql2'
require 'active_support/inflector'

module Bagatelle
  class MysqlStorage
    attr_accessor :connection

    def initialize(params)
      @connection ||= Mysql2::Client.new(params)
    end

    def query(table, key, value)
      connection.query(build_query(table, key, value))
    end

    def build_query(table, key, value)
      wrapped_val = "IN(#{value.join(', ')})"
      "SELECT * FROM #{table} WHERE #{key} #{wrapped_val}"
    end
  end

  class LocalStorage
    attr_accessor :data

    def initialize(params)
      @data = params
    end

    def query(table, key, value)
      data[table].select { |entry| value.include?(entry[key]) }
    end
  end

  class Mapper
    attr_reader :client

    def initialize(client)
      @client = client
    end

    class << self
      attr_reader :associations

      def children(*children)
        @associations = children
      end
    end

    def associations
      self.class.associations
    end

    def recursive_map(table, key, value, children=[])
      ids = []
      rel = []
      fkey = table.singularize.foreign_key

      # client.query(client.build_query(table, key, value)).each do |row|
      client.query(table, key, value).each do |row|
        ids << row['id']
        child_hash = Hash.new

        children.each do |child|
          if child.respond_to?(:each_pair)
            child.each_pair do |k, v|
              child_hash[k] = recursive_map(k.to_s, fkey, ids, Array(v))
            end
          else
            child_hash[child] = recursive_map(child.to_s, fkey, ids)
          end
        end

        klass = table.classify.constantize
        rel << klass.new(row.merge(child_hash))
      end
      rel
    end
  end
end
