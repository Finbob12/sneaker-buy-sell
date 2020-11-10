module ApplicationHelper

    def get_message_alerts(current_user)
        conversations = Conversation.where(sender: current_user) + Conversation.where(recipient: current_user)
        unread_messages = Message.where("user_id != ? AND read = ?", current_user.id, false).where(conversation_id: [conversations]).count
     
        if unread_messages == 0
            return link_to "Messages", conversations_path, class: "nav-link bg-danger"
        else
           return link_to "Messages", conversations_path, class: "nav-link"
        end

      end
end
