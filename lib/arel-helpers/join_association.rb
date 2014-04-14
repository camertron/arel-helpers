# encoding: UTF-8

module ArelHelpers
  module JoinAssociation

    # activerecord uses JoinDependency to automagically generate inner join statements for
    # any type of association (belongs_to, has_many, and has_and_belongs_to_many).
    # For example, for HABTM associations, two join statements are required.
    # This method encapsulates that functionality and returns a SelectManager for chaining.
    # It also allows you to use an outer join instead of the default inner via the join_type arg.
    def join_association(table, association, join_type = Arel::InnerJoin)
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

  end
end