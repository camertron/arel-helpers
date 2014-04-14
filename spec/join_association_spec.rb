# encoding: UTF-8

require 'spec_helper'

describe ArelHelpers::JoinAssociation do
  include ArelHelpers::JoinAssociation

  describe "#join_association" do
    it "should work for a directly associated model" do
      Post.joins(join_association(Post, :comments)).to_sql.should ==
        'SELECT "posts".* FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id"'
    end

    it "should work with an outer join" do
      Post.joins(join_association(Post, :comments, Arel::OuterJoin)).to_sql.should ==
        'SELECT "posts".* FROM "posts" LEFT OUTER JOIN "comments" ON "comments"."post_id" = "posts"."id"'
    end

    it "should allow adding additional join conditions" do
      Post.joins(join_association(Post, :comments) do |assoc_name, join_conditions|
        join_conditions.and(Comment[:id].eq(10))
      end).to_sql.should ==
        'SELECT "posts".* FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" AND "comments"."id" = 10'
    end

    it "should work for two models, one directly associated and the other indirectly" do
      Post
        .joins(join_association(Post, :comments))
        .joins(join_association(Comment, :commenter))
        .to_sql.should ==
          'SELECT "posts".* FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" INNER JOIN "commenters" ON "commenters"."comment_id" = "comments"."id"'
    end

    it "should be able to handle multiple associations" do
      Post.joins(join_association(Post, [:comments, :favorites])).to_sql.should ==
        'SELECT "posts".* FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" INNER JOIN "favorites" ON "favorites"."post_id" = "posts"."id"'
    end

    it "should yield once for each association" do
      Post.joins(join_association(Post, [:comments, :favorites]) do |assoc_name, join_conditions|
        case assoc_name
          when :favorites
            join_conditions.or(Favorite[:amount].eq("lots"))
          when :comments
            join_conditions.and(Comment[:text].eq("Awesome post!"))
        end
      end).to_sql.should ==
        'SELECT "posts".* FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" AND "comments"."text" = \'Awesome post!\' INNER JOIN "favorites" (ON "favorites"."post_id" = "posts"."id" OR "favorites"."amount" = \'lots\')'
    end
  end
end
