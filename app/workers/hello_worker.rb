require 'sidekiq'

class HelloWorker
  include Sidekiq::Worker

  def perform(param)
    # Do something
    # User delete(# Rating
    #likes
    #comments
    #bookings)

    Architect (design , bookings)
    
    def destroy
      Worker.perform_asyn(user_id: params[:id])
      head 
      head :no_content
  end
end
