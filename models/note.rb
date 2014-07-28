require 'grape-entity'

module Notes
  class Note < ActiveRecord::Base
    include Grape::Entity::DSL
    validates_presence_of :title

    entity :id, :title do
      format_with(:custom_timestamp) { |dt| dt.to_json.gsub('"', '').gsub('/', '-') }
      expose :created_at, format_with: :custom_timestamp
    end
  end
end
