require 'digest'

# This model expects a certain database layout and its based on the name/login
# pattern.

# created using the login generator available at
# http://www.rubyonrails.org/show/Generators
class Author < ActiveRecord::Base

  belongs_to :approved_by, :class_name => 'Author',
             :foreign_key => 'approved_by_id'

  has_many :inductees, :class_name => 'Author', :foreign_key => 'approved_by_id'

  before_create :crypt_password

  validates_length_of :password, :login, :within => 3..80
  validates_presence_of :name, :login, :email, :password
  validates_uniqueness_of :login, :on => :create
  validates_confirmation_of :password, :on => :create

  def self.authenticate(login, password)
    find :first,
         :conditions => ['approved_by_id IS NOT NULL AND login = ? AND password = ?',
                         login, crypt(password)]
  end

  def self.crypt(password)
    Digest::SHA1.hexdigest "~hieraki--#{password}--"
  end

  def approve(patron)
    self.approved_by = patron
    @freshly_approved = true
  end

  def change_password(password)
    update_attribute 'password', self.class.crypt(password)
  end

  def freshly_approved?
    @freshly_approved
  end

  private

  def crypt_password
    write_attribute 'password', self.class.crypt(password) if
      password == @password_confirmation
  end

end
