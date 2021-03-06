class Message < ActiveRecord::Base
	belongs_to :sender, :class_name => "User"
	belongs_to :receiver, :class_name => "User"
	has_one :notification

	after_create :create_notification

	def create_notification
		Notification.create(:user_id => receiver.id, :message_id => self.id)
		if receiver.email_notification
			begin
				MessageMailer.new_message_notification(self).deliver
			rescue Exception
			end
		end
	end

	def preview
		self.text.truncate(30)
	end

	def other_user(user)
		user == sender ? receiver : sender
	end
end
