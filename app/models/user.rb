class User < ApplicationRecord

  attr_accessor :created_by_seed

  has_secure_password

  belongs_to :role, optional: true

  before_save :set_user_role, unless: :created_by_seed

  before_save :set_user_status

  validates :email, presence: true
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  scope :all_except, ->(user) { where.not(id: user)}
  STATUS_PENDING = 'Pending'.freeze
  STATUS_APPROVED = 'Approved'.freeze
  STATUS_REJECTED = 'Rejected'.freeze


  def created_by_seed?
     created_by_seed == true
  end    

  def set_user_role     	
  	self.role = Role.find_by_name("User")
  end

  def set_user_status
    self.status ||= User::STATUS_PENDING
  end

end
