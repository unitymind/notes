require 'grape-entity'

module Notes
  class Note < ActiveRecord::Base
    include Grape::Entity::DSL
    validates_presence_of :title

    entity :id, :title, :created_at
  end
end
