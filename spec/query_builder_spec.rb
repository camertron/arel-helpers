require 'spec_helper'

class TestQueryBuilder < ArelHelpers::QueryBuilder
  attr_accessor :params
  alias_method :params?, :params

  def initialize(query = nil)
    super(query || Post.unscoped)

    # only necessary for the test environment to prevent pollution between tests
    @query.reload
  end

  def noop
    reflect(query)
  end

  not_nil def optional(skip:)
    reflect(query.where(title: 'BarBar')) unless skip
  end
end

describe ArelHelpers::QueryBuilder do
  let(:builder) { TestQueryBuilder.new }

  it 'returns (i.e. reflects) new instances of QueryBuilder' do
    builder.tap do |original_builder|
      original_builder.params = true
      new_builder = original_builder.noop
      expect(new_builder.object_id).not_to eq original_builder.object_id
      expect(new_builder.params?).to be true
    end
  end

  it 'forwards #to_a' do
    Post.create(title: 'Foobar')
    builder.to_a.tap do |posts|
      expect(posts.size).to eq 1
      expect(posts.first.title).to eq 'Foobar'
    end
  end

  it 'forwards #to_sql' do
    expect(builder.to_sql.strip).to eq 'SELECT "posts".* FROM "posts"'
  end

  it 'forwards #each' do
    created_post = Post.create(title: 'Foobar')
    builder.each do |post|
      expect(post).to eq created_post
    end
  end

  it 'forwards other enumerable methods via #each' do
    Post.create(title: 'Foobar')
    expect(builder.map(&:title)).to eq ['Foobar']
  end

  it 'forwards #empty?' do
    expect(builder.empty?).to eq true
  end

  it 'forwards #size' do
    expect(builder.size).to eq 0
  end

  ArelHelpers::QueryBuilder::TERMINAL_METHODS.each do |method|
    it "does not enumerate records for #{method}" do
      allow(builder).to receive :each
      builder.public_send(method)
      expect(builder).not_to have_received :each
    end
  end

  it 'returns reflect on existing query if method returns a falsy value' do
    expect(builder.optional(skip: true).to_sql.strip).to eq 'SELECT "posts".* FROM "posts"'
  end

  it 'returns reflect on new query for default chainable method if value is truthy' do
    expect(builder.optional(skip: false).to_sql.strip.gsub(/\s+/, ' ')).to eq <<-SQL.squish
      SELECT "posts".* FROM "posts" WHERE "posts"."title" = 'BarBar'
    SQL
  end
end
