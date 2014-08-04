# Ensure the jobs run only in a web server.
if defined?(Rails::Server)
  FistOfFury.attack! do
    Inprogress.recurs { daily.hour_of_day(23) }
    Return.recurs { daily.hour_of_day(5) }
    # Noresponse.recurs { daily.hour_of_day(23) }
    Outstanding.recurs { daily.hour_of_day(18) }
  end
end
