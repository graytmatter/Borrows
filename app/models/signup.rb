class Signup < ActiveRecord::Base

	validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
    validates :name, presence: true, length: { maximum: 50 }

def add_subscrip
    connection = GoogleDrive.login(ENV['g_username'], ENV['g_password'])
    ss = connection.spreadsheet_by_title(ENV['spreadsheet_title'])
    ws = ss.worksheets[0]
    row = 3 + ws.num_rows 
    ws[row, 1] = self.name
    ws[row, 2] = Time.new
    ws[row, 3] = self.email
    ws.save
end

end
