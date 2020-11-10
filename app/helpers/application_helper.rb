module ApplicationHelper

    def get_message_alerts(current_user)
        conversations = Conversation.where(sender: current_user) + Conversation.where(recipient: current_user)
        unread_messages = Message.where("user_id != ? AND read = ?", current_user.id, false).where(conversation_id: [conversations]).count
     
        if unread_messages == 0
            return link_to "Messages", conversations_path, class: "btn btn-warning"
        else
           return link_to "Messages", conversations_path
        end

      end

    def get_chat_users(conv)
        if conv.sender == current_user
            link_to conv.recipient.username, conversation_messages_path(conv), class: "btn btn-warning"
        elsif conv.sender != current_user
            link_to conv.sender.username, conversation_messages_path(conv), class: "btn btn-warning"
        else
            return
        end
    end

    def get_message_notifications(conv)
        if conv.messages.last.user != current_user
            "received new message #{time_ago_in_words(conv.messages.last.updated_at)} ago from"

        else
            " you sent a message #{time_ago_in_words(conv.messages.last.updated_at)} ago to"
        end
    end
end
