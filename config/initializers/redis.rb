if Rails.env.test?
  REDIS = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/2")
else
  REDIS = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/1")
end