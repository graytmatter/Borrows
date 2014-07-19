module Dateoverlap

  def do_dates_overlap(second_record)
    test = ((self.pickupdate - second_record.returndate) * (second_record.pickupdate - self.returndate)).to_i
    if test > 0
      return "yes"
    elsif test == 0
      return "edge"
    elsif test < 0
      return "no"
    end
  end
  
end