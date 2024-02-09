# frozen_string_literal: true

# Module to include helper methods for the PaginationHelper.
# These methods can be used across different parts of the design views and controllers.
# This module includes the Pagy::Frontend module, providing convenient
# frontend methods for handling pagination using the Pagy gem.
module PaginationHelper
  include Pagy::Frontend
end
