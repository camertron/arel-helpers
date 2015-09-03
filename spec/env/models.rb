# encoding: UTF-8

class Post < ActiveRecord::Base
  include ArelHelpers::ArelTable
  include ArelHelpers::Aliases
  has_many :comments
  has_many :favorites
end

class Comment < ActiveRecord::Base
  include ArelHelpers::ArelTable
  include ArelHelpers::Aliases
  belongs_to :post
  belongs_to :author
end

class Author < ActiveRecord::Base
  include ArelHelpers::ArelTable
  include ArelHelpers::Aliases
  has_one :comment
  has_and_belongs_to_many :collab_posts
end

class Favorite < ActiveRecord::Base
  include ArelHelpers::ArelTable
  include ArelHelpers::Aliases
  belongs_to :post
end

class CollabPost < ActiveRecord::Base
  include ArelHelpers::ArelTable
  include ArelHelpers::Aliases
  has_and_belongs_to_many :authors
end
