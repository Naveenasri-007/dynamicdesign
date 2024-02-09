# frozen_string_literal: true

# ApplicationRecord is the base class for all models in the application.
# It extends ActiveRecord::Base and includes common functionality shared
# by all models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
