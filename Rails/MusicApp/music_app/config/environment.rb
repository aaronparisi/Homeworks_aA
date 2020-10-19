# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "localhost:3000",
    authentication:       "plain",
    user_name:            "aarons.coding.stuff@gmail.com",
    password:             "xzyzpleyzloizsxq",# "Booga300&@",
    enable_starttls_auto: true
  }
end