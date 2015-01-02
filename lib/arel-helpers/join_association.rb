# encoding: UTF-8

module ArelHelpers

  module JoinAssociation
    extend ActiveSupport::Concern

    module ClassMethods
      def join_association(*args, &block)
        ArelHelpers::JoinAssociation.join_association(self, *args, &block)
      end
    end

    class << self
      # activerecord uses JoinDependency to automagically generate inner join statements for
      # any type of association (belongs_to, has_many, and has_and_belongs_to_many).
      # For example, for HABTM associations, two join statements are required.
      # This method encapsulates that functionality and yields an intermediate object for chaining.
      # It also allows you to use an outer join instead of the default inner via the join_type arg.
      def join_association(table, association, join_type = Arel::Nodes::InnerJoin, &block)
        if ActiveRecord::VERSION::STRING >= '4.2.0'
          join_association_4_2(table, association, join_type, &block)
        elsif ActiveRecord::VERSION::STRING >= '4.1.0'
          join_association_4_1(table, association, join_type, &block)
        else
          join_association_3_1(table, association, join_type, &block)
        end
      end

      private

      def join_association_3_1(table, association, join_type)
        associations = association.is_a?(Array) ? association : [association]
        join_dependency = ActiveRecord::Associations::JoinDependency.new(table, associations, [])
        manager = Arel::SelectManager.new(table)

        join_dependency.join_associations.each do |assoc|
          assoc.join_type = join_type
          assoc.join_to(manager)
        end

        manager.join_sources.map do |assoc|
          if block_given?
            # yield |assoc_name, join_conditions|
            right = yield assoc.left.name.to_sym, assoc.right
            assoc.class.new(assoc.left, right)
          else
            assoc
          end
        end
      end

      def join_association_4_1(table, association, join_type)
        associations = association.is_a?(Array) ? association : [association]
        join_dependency = ActiveRecord::Associations::JoinDependency.new(table, associations, [])

        join_dependency.join_constraints([]).map do |constraint|
          right = if block_given?
                    yield constraint.left.name.to_sym, constraint.right
                  else
                    constraint.right
                  end

          join_type.new(constraint.left, right)
        end
      end

      def join_association_4_2(table, association, join_type)
        associations = association.is_a?(Array) ? association : [association]
        join_dependency = ActiveRecord::Associations::JoinDependency.new(table, associations, [])

        join_dependency.join_constraints([]).map do |constraint|
          constraint.joins.map do |join|
            right = if block_given?
                      yield join.left.name.to_sym, join.right
                    else
                      join.right
                    end

            join_type.new(join.left, right)
          end
        end
      end
    end
  end
end
