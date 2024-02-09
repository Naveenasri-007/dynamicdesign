# frozen_string_literal: true

require 'sidekiq'

# UserWorker is a Sidekiq worker responsible for performing tasks related to Users.
# It includes functionality to find and delete an user by ID.
class UserWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    user.destroy
  end
end
