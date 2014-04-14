# encoding: UTF-8

module ArelHelpers
  module ArelTable

    extend ActiveSupport::Concern

    module ClassMethods

      def [](name)
        arel_table[name]
      end

    end

  end
end