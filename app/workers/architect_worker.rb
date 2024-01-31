require 'sidekiq'

class ArchitectWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(architect_id)
    architect = Architect.find(architect_id)
    architect.destroy
  end
end
