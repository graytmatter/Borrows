# Ensure the jobs run only in a web server.
if defined?(Rails::Server)
  FistOfFury.attack! do
    Inprogress.recurs { minutely }
    Return.recurs { minutely }
    Noresponse.recurs { minutely }
    Outstanding.recurs { daily.hour_of_the_day(12) }
  end
end
