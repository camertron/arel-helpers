# encoding: UTF-8

require 'spec_helper'

class TestQueryBuilder < ArelHelpers::QueryBuilder
  attr_accessor :params
  alias_method :params?, :params

  def initialize(query = nil)
    super(query || Post.unscoped)
  end

  def noop
    reflect(query)
  end

  not_nil def optional(skip:)
    reflect(query.where(title: "BarBar")) unless skip
  end
end

describe ArelHelpers::QueryBuilder do
  let(:builder) { TestQueryBuilder.new }

  it "returns (i.e. reflects) new instances of QueryBuilder" do
    builder.tap do |original_builder|
      original_builder.params = true
      new_builder = original_builder.noop
      new_builder.object_id.should_not == original_builder.object_id
      new_builder.params?.should == true
    end
  end

  it "forwards #to_a" do
    Post.create(title: "Foobar")
    builder.to_a.tap do |posts|
      posts.size.should == 1
      posts.first.title.should == "Foobar"
    end
  end

  it "forwards #to_sql" do
    builder.to_sql.strip.should == 'SELECT "posts".* FROM "posts"'
  end

  it "forwards #each" do
    created_post = Post.create(title: "Foobar")
    builder.each do |post|
      post.should == created_post
    end
  end

  it "forwards other enumerable methods via #each" do
    Post.create(title: "Foobar")
    builder.map(&:title).should == ["Foobar"]
  end

  ArelHelpers::QueryBuilder::TERMINAL_METHODS.each do |method|
    it "does not enumerate records for #{method}" do
      mock(builder).each.never
      builder.public_send(method)
    end
  end

  it "returns reflect on existing query if method returns a falsy value" do
    builder.optional(skip: true).to_sql.strip.should == 'SELECT "posts".* FROM "posts"'
  end

  it "returns reflect on new query for default chainable method if value is truthy" do
    builder.optional(skip: false).to_sql.strip.gsub(/\s+/, " ").should == %Q{
      SELECT \"posts\".* FROM \"posts\" WHERE \"posts\".\"title\" = 'BarBar'
    }.strip
  end
end
