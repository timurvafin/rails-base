class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         email_regexp: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  attr_accessible :full_name, :email, :password, :password_confirmation, :remember_me

  validates :full_name, presence: true
  validates_confirmation_of :password

  def to_s
    full_name
  end

  def full_name_with_email
    "#{self[:full_name]} (#{email})"
  end
end
