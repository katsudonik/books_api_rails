class ChatMessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    chat_messages = ChatMessage.all
    render(
      json: chat_messages,
      root: 'chat_messages',
      adapter: :json
    )
  end
end
