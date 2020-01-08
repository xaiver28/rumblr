class User < ActiveRecord::Base
  validates :email, :password, presence: true
  validates :email, uniqueness: true

  has_many :posts, dependent: :destroy
end
class Post <ActiveRecord::Base
validates :title, :content, :user_id, length: {maximum:300}

belongs_to :user
end
