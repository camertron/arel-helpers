# encoding: UTF-8

require 'rspec'
require 'arel-helpers'
require 'fileutils'
require 'pry-nav'

def silence(&block)
  original_stdout = $stdout
  $stdout = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
end

class Post < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :comments
  has_many :favorites
end

class Comment < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :post
  has_one :commenter
end

class Commenter < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :comment
end

class Favorite < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :post
end

class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts
  end
end

class CreateCommentsTable < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post
    end
  end
end

class CreateCommentersTable < ActiveRecord::Migration
  def change
    create_table :commenters do |t|
      t.references :comment
    end
  end
end

class CreateFavoritesTable < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :post
    end
  end
end

RSpec.configure do |config|
  config.mock_with :rr

  db_dir = File.join(File.dirname(File.dirname(__FILE__)), "tmp")
  db_file = File.join(db_dir, "test.sqlite3")

  config.before(:each) do
    File.unlink(db_file) if File.exist?(db_file)
    FileUtils.mkdir_p(db_dir)

    ActiveRecord::Base.establish_connection(
      :adapter  => "sqlite3",
      :database => db_file
    )

    silence do
      CreatePostsTable.new.change
      CreateCommentsTable.new.change
      CreateCommentersTable.new.change
      CreateFavoritesTable.new.change
    end
  end
end
