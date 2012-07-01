class Wall
  include Mongoid::Document
  field :title, :type => String
  field :name, :type => String
  field :query, :type => String
  field :refresh_time, :type => Integer, :default => 4000
  field :rpp, :type => Integer, :default => 35
  field :published, :type => Boolean, :default => false

  embedded_in :user

  attr_accessible :title, :name, :query, :refresh_time, :rpp, :published

  validates_presence_of :title, :name, :query
  validates_uniqueness_of :name

  before_validation(:on => :create) do
    self.name = name.parameterize
  end

  def published?
    published
  end

  def self.find_published_by_nickname_and_wall_name(nickname, wall_name)
    user = User.where("nickname" => nickname).first
    if user
      wall = user.walls.find_by_name(wall_name).first
      if wall.published?
        wall
      else
        nil
      end
    else
      nil
    end
  end
end
