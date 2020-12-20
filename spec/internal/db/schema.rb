# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.column :title, :string
  end

  create_table :comments do |t|
    t.references :post
  end

  create_table :authors do |t|
    t.references :comment
    t.references :collab_posts
  end

  create_table :favorites do |t|
    t.references :post
  end

  create_table :collab_posts do |t|
    t.references :authors
  end

  create_table :cards

  create_table :card_locations do |t|
    t.references :location
    t.references :card, polymorphic: true
  end

  create_table :locations
  create_table :community_tickets
end
