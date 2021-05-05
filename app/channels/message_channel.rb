class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_channel"
  end

  def speak(data)
    Message.create! content: data['message']
  end
end