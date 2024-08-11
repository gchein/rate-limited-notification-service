RATE_LIMIT_RULES = YAML.safe_load(File.read('config/rate_limits.yml'), symbolize_names: true).freeze

unless RATE_LIMIT_RULES.is_a?(Hash) && RATE_LIMIT_RULES.all? { |key, value| key.is_a?(Symbol) && value.is_a?(Hash) }
  raise "Invalid Rate Limit Rules formatting!"
end
