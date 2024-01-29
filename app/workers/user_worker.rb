require 'sidekiq'

class UserWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    user.destroy
  end
end

