class MessagesController < ApplicationController
    before_action do
     @conversation = Conversation.find(params[:conversation_id])
    end

    # find all messages in relevant conversation table being accessed then
    # updates these to read if they are unread. Logic to differenciate sender
    # and recipient so every user can't see every other users conversations.

    def index
    @messages = @conversation.messages
    @messages.where("user_id != ? AND read = ?", current_user.id, false).update_all(read: true)
    if @conversation.sender == current_user
      @msg_not = @conversation.recipient
    else
      @msg_not = @conversation.sender
    end
      if current_user != @conversation.sender 
        if current_user != @conversation.recipient
        redirect_to conversations_path
        end
      end
      @message = @conversation.messages.new
    end

    def new
        @message = @conversation.messages.new
    end

    # Create a new message associated to the current conversation
    # and adds it to the table
    def create
        @message = @conversation.messages.new(message_params)
        if @message.save
        redirect_to conversation_messages_path(@conversation)
        end
    end

    #accepted parameters for message creation
    private
        def message_params
        params.require(:message).permit(:body, :user_id)
    end
end