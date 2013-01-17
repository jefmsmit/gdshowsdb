module Extensions
  module UUID
    extend ActiveSupport::Concern

    included do
      primary_key = 'uuid'
    end
  end
end