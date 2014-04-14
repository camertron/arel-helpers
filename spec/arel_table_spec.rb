# encoding: UTF-8

require 'spec_helper'

describe ArelHelpers::ArelTable do
  it "should add the [] function to the model and allow attribute access" do
    Post[:id].tap do |post_id|
      post_id.should be_a(Arel::Attribute)
      post_id.name.should == :id
      post_id.relation.name.should == "posts"
    end
  end
end
