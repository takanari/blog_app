require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :posts
  validates_presence_of :name, :email, :password
  before_save :encrypt_password
  def encrypt_password
    if self.password.present?
      self.password = Digest::SHA1.hexdigest(self.password)
    else
      self.password = self.password_was 
      #空のときはパスワードを変更しない
    end
  end

  def registered?
    u = User.where(email: self.email).first
    if u && u.password == Digest::SHA1.hexdigest(self.password)
      self.id = u.id
      true
    else
      false
    end
  end

end
