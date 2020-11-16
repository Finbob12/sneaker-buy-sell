class Message < ActiveRecord::Base
    belongs_to :conversation
    belongs_to :user
    validates_presence_of :body, :conversation_id, :user_id
    validates :body, format: { with: /^[ -~]*$/, :multiline => true, message: "should only contain characters you can type on keyboard" }
   end