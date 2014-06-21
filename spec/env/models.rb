# encoding: UTF-8

class Post < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :comments
  has_many :favorites
end

class Comment < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :post
  has_one :author
end

class Author < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :comment
end

class Favorite < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :post
end
