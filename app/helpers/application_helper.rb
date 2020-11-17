module ApplicationHelper

    #Checks if any messages pertaining to current_user have yet to be viewed. If any are unread, the bootstrap class bg-danger is added to the messages nav link
    #to alert the user to an unread message
    def message_alert(current_user)
        conversations = Conversation.where(sender: current_user) + Conversation.where(recipient: current_user)
        unread_messages = Message.where("user_id != ? AND read = ?", current_user.id, false).where(conversation_id: [conversations]).count
        if unread_messages == 0
            return link_to "Messages", conversations_path, class: "nav-link"
        else
           return link_to "Messages", conversations_path, class: "nav-link bg-danger"
        end

      end
end
