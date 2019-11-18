# encoding: UTF-8

require 'forwardable'
require 'enumerator'

module ArelHelpers
  module DefaultQueryChain
    def chain(name)
      mod = Module.new do
        define_method(name) do |*args|
          if (value = super(*args))
            value
          else
            reflect(query)
          end
        end
      end

      prepend mod
      name
    end
  end

  class QueryBuilder
    extend Forwardable
    include Enumerable

    attr_reader :query
    def_delegators :@query, :to_a, :to_sql, :each

    TERMINAL_METHODS = [:count, :first, :last]
    TERMINAL_METHODS << :pluck if ActiveRecord::VERSION::MAJOR >= 4

    def_delegators :@query, *TERMINAL_METHODS

    def initialize(query)
      @query = query
    end

    protected

    def reflect(query)
      dup.tap { |obj| obj.instance_variable_set('@query'.freeze, query) }
    end
  end
end
