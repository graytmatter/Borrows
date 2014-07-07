desc "Send email to connect borrower/lender pairs for items found"

task :connect_email => :environment do 
	RequestMailer.found_email(eval(ENV["requestrecord"]), eval(ENV["lender_array"]), ENV["item"], ENV["quantity"]).deliver unless lender_array.blank?
end