Prelaunchr::Application.configure do
  config.action_mailer.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :enable_starttls_auto => true,
    :user_name => "mazharul@freelancer@gmail.com",
    :password  => "yQSESKBjVJUYE6CqPI_AjA",
    :authentication => 'login',
    :domain => '104.131.201.173'
  }
end