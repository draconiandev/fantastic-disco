# frozen_string_literal: true

REDIS_CONFIG = YAML.safe_load(File.open(Rails.root.join('config', 'redis.yml'))).symbolize_keys
default = REDIS_CONFIG[:default].symbolize_keys
config = default.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys) if REDIS_CONFIG[Rails.env.to_sym]

# Redis.current = Redis.new(config)
Redis.current = if Rails.env.production?
                  uri = URI.parse(Rails.application.secrets.redis_url)
                  Redis.new(url: uri)
                else
                  Redis.new(config)
                end

Redis.current.flushdb if Rails.env == 'test'
