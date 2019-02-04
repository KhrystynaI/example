class MessagesController < ApplicationController
  before_action :authenticate_autor!

  def create
    @message = Message.new(message_params)
    @message.autor = current_autor
    @message.save
  end

private

def message_params
  params.require(:message).permit(:body)
end

end
