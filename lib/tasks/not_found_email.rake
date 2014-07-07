desc "Send email to james@projectborrow.com for items found/ quantity not enough"

task :not_found_email => :environment do 
	RequestMailer.not_found_email(eval(ENV["requestrecord"]), eval(ENV["matched_inventory"]), ENV["item"], ENV["quantity"]).deliver
end