class Signup < ActiveRecord::Base
    has_many :inventories, dependent: :destroy
    has_many :requests
    
    before_save :downcase_email

    # validate :create_validation, on: :create
    # validate :update_validation, on: :update

    # def create_validation
    #     errors[:base] << "Please enter a valid email address to continue" if self.email.blank? || (( /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i =~ self.email) == nil) 
    # end

    # def update_validation
    #     errors[:base] << "Please enter two different cross streets so we can find items closer to you" if self.streetone.blank? || self.streettwo.blank? || ( self.streetone == self.streettwo )
    #     errors[:base] << "Please enter a valid 5-digit zipcode so we can find items closer to you" if self.zipcode.blank? || (self.zipcode.to_i < 0) || (self.zipcode.to_s.strip.length != 5)
    #     errors[:base] << "Please agree to the terms of service before continuing" unless self.tos == true
    # end

    def downcase_email
        if self.email.present? 
            self.email = self.email.downcase
        end
    end

    def save_signup(id, name, location, access_token)
        self.facebook_id = id
        self.name = name
        self.image_url = "http://graph.facebook.com/#{id}/picture"
        self.fb_location = location
        self.fb_access_token = access_token
        self.save
    end


=begin
    def add_subscrip
        mailchimp = Gibbon::API.new 
        result = mailchimp.lists.subscribe({ 
            :id => ENV['MAILCHIMP_LIST_ID'], 
            :email => {:email => self.email}, 
            :double_optin => false, 
            :update_existing => true, 
            :send_welcome => true 
        })
        Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
    end
=end


end
