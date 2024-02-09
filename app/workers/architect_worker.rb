# frozen_string_literal: true

require 'sidekiq'

# ArchitectWorker is a Sidekiq worker responsible for performing tasks related to architects.
# It includes functionality to find and delete an architect by ID.
class ArchitectWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(architect_id)
    architect = Architect.find_by(id: architect_id)
    return unless architect

    architect.destroy
  end
end
