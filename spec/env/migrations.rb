# encoding: UTF-8

class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.column :title, :string
    end
  end
end

class CreateCommentsTable < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post
    end
  end
end

class CreateAuthorsTable < ActiveRecord::Migration
  def change
    create_table :authors do |t|
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
