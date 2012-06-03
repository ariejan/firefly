class Settings < Settingslogic
  source "#{Rails.root}/config/firefly.yml"
  namespace Rails.env
end
