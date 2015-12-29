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
      t.references :collab_posts
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

class CreateCollabPostsTable < ActiveRecord::Migration
  def change
    create_table :collab_posts do |t|
      t.references :authors
    end
  end
end

class CreateCardsTable < ActiveRecord::Migration
  def change
    create_table :cards
  end
end

class CreateCardLocationsTable < ActiveRecord::Migration
  def change
    create_table :card_locations do |t|
      t.references :location
      t.references :card, polymorphic: true
    end
  end
end

class CreateLocationsTable < ActiveRecord::Migration
  def change
    create_table :locations
  end
end

class CreateCommunityTicketsTable < ActiveRecord::Migration
  def change
    create_table :community_tickets
  end
end
