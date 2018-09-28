CarrierWave.configure do |config|

  case Rails.env
  when 'production'
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
        provider:              'AWS',                        # required
        aws_access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),                        # required
        aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),                        # required
        region:                ENV.fetch('AWS_REGION'),                  # optional, defaults to 'us-east-1'
        host:                  ENV.fetch('AWS_HOST'),             # optional, defaults to nil
        endpoint:              ENV.fetch('AWS_ENDPOINT') # optional, defaults to nil
    }
    config.fog_directory  = ENV.fetch('AWS_BUCKET')                                   # required
    config.fog_public     = true                                                 # optional, defaults to true
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
    config.storage = :fog # この位置になければエラー発生（config.fog_provider）の上ではダメ
  else
    config.storage = :file
  end
end
