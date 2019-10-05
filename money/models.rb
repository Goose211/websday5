
class User < ActiveRecord::Base
  has_secure_password
  has_many :posts
end

class Post < ActiveRecord::Base
belongs_to :user
end
 ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
