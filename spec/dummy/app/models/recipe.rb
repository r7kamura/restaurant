class Recipe < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :title

  validates :title, :presence => true
end
