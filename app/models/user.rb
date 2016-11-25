class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :login_id, :password_digest, :password, :password_confirmation
  has_secure_password

end

