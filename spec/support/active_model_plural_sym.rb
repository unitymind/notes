module ActiveModel
  module Naming
    def singular_sym
      model_name.singular.to_sym
    end
  end
end