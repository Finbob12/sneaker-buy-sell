class ConversationsController < ApplicationController
    before_action :authenticate_user!

    #initialize all users and conversations
    
    def index
      @users = User.all
      @conversations = Conversation.all
    end

    #called when message created by checking sender and recipient ids,
    # to check if a conversation between two users already exists. If one does not exist
    # new messages will be created associated with that conversation row. Otherwise
    # a new conversation row will be created for messages to be associated with.

    def create
        if Conversation.between(params[:sender_id],params[:recipient_id])
          .present?
          @conversation = Conversation.between(params[:sender_id],
            params[:recipient_id]).first
        else
          @conversation = Conversation.create!(conversation_params)
        end
      redirect_to conversation_messages_path(@conversation)
    end

    private

    def conversation_params
        params.permit(:sender_id, :recipient_id)
    end

end