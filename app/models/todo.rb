class Todo < ActiveRecord::Base
  attr_accessible :title, :completed, :priority
  belongs_to :user
end
