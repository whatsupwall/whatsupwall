class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Omniauthable
  devise :omniauthable
  field :uid

  field :name,      :type => String
  field :nickname,  :type => String
  validates_presence_of :name
  validates_uniqueness_of :nickname, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  embeds_many :walls do
    def find(id)
      where(:_id => id).first
    end
    def find_by_name(name)
      where(:name => name)
    end
  end

  before_validation(:on => :create) do
    self.nickname = self.name if (self.nickname == nil)
    self.nickname = nickname.parameterize
  end

  validate :uniqueness_of_email
  def uniqueness_of_email
    existing_users = User.where(:email => email)
    existing_users.each do |user|
      errors.add(:email, "is already taken") unless (user.uid != nil)
    end
  end

  def update_with_password(params = {})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    params.delete(:walls)
    update_attributes(params)
  end

  def email_required?
    false
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource = nil)
    data = access_token.extra.raw_info
    if user = self.where(:uid => access_token.uid).first
      user
    else # Create a user with a stub password.
      user = User.new
      user.uid = access_token.uid
      user.name = data.name
      user.password = Devise.friendly_token[0,20]
      user.save :validate => false
      user
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource = nil)
    data = access_token.extra.raw_info
    if user = self.where(:email => data.email).first
      user
    else # Create a user with a stub password.
      self.create!(:uid => access_token.uid, :email => data.email,
        :name => data.name, :password => Devise.friendly_token[0,20])
    end
  end

  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
end
