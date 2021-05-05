class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_channel"
  end

  def speak(data)
    ChatMessage.create! content: data['message']
  end
end