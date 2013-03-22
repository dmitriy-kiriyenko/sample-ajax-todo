class Todo < ActiveRecord::Base
  attr_accessible :title, :completed, :priority
end
