require 'sidekiq'

class ArchitectWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(architect_id)
    architect = Architect.find_by(id: architect_id)
    return unless architect

    architect.destroy
  end
end
