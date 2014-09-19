class Referral
	include SuckerPunch::Job

	def perform(emails, referer)
		ActiveRecord::Base.connection_pool.with_connection do
			emails.each do |e|
				unless Signup.where(email: e.strip.downcase).present? || Invitee.where(sent: true).where(email: e.strip.downcase).present?
	        @invitee = Invitee.find_or_create_by(email: e.strip.downcase) do |i|
	          i.referer = referer
	        end      
	      	InviteeMailer.invitation_email(@invitee.id).deliver
	      end
	    end

		end
	end
end