module Extensions
  module UUID
    extend ActiveSupport::Concern

    included do
      self.primary_key = 'uuid'
    end
  end
end