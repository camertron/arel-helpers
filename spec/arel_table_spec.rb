require 'spec_helper'

describe ArelHelpers::ArelTable do
  it 'should add the [] function to the model and allow attribute access' do
    Post[:id].tap do |post_id|
      expect(post_id).to be_a Arel::Attribute
      expect(post_id.name.to_s).to eq 'id'
      expect(post_id.relation.name).to eq 'posts'
    end
  end

  it 'should not interfere with associations' do
    post = Post.create(title: "I'm a little teapot")
    expect(post.comments[0]).to be_nil
  end

  it 'should allow retrieving associated records' do
    post = Post.create(title: "I'm a little teapot")
    comment = post.comments.create
    expect(post.reload.comments[0].id).to eq comment.id
  end

  it 'does not interfere with ActiveRecord::Relation objects' do
    expect(Post.all[0]).to be_nil
    p = Post.create(title: 'foo')
    expect(Post.all[0].id).to eq p.id
  end
end
