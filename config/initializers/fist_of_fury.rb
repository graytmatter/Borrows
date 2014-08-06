# Ensure the jobs run only in a web server.
if defined?(Rails::Server)

FistOfFury.configure do |config|
  config.utc = true # false by default; makes all time within Fist of Fury UTC
end

  FistOfFury.attack! do
    Inprogress.recurs { daily.hour_of_day(23) }
    Return.recurs { daily.hour_of_day(5) }
    # Noresponse.recurs { daily.hour_of_day(23) }
    Outstanding.recurs { daily.hour_of_day(18) }
  end
end
