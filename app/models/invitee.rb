class Invitee < ActiveRecord::Base

	before_save :downcase_email

	# validates :referer, presence: true
	validates :email, presence: true
	# validates :sent, presence: true 

  def downcase_email
      self.email = self.email.downcase
  end
end
