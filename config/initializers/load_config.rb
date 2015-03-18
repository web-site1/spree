APP_CONFIG = YAML.load_file("#{ Rails.root }/config/settings.yml")[Rails.env].symbolize_keys
COMP_ID    = APP_CONFIG[:comp_id]
