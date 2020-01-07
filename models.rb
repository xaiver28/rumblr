class User < ActiveRecord::Base
  validates :email, :password, presence: true
  validates :email, uniqueness: true

end
class Post <ActiveRecord::Base
validates :title, :content, :user_id, length: {maximum:300}
end
