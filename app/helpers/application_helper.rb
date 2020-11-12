module ApplicationHelper

    def get_message_alerts(current_user)
        conversations = Conversation.where(sender: current_user) + Conversation.where(recipient: current_user)
        unread_messages = Message.where("user_id != ? AND read = ?", current_user.id, false).where(conversation_id: [conversations]).count
    #  needs method below to alert user to unread messages
        if unread_messages == 0
            return link_to "Messages", conversations_path, class: "nav-link"
        else
           return link_to "Messages", conversations_path, class: "nav-link bg-danger"
        end

      end
end
