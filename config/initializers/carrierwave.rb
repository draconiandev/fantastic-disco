# frozen_string_literal: true

module CarrierWave
  module MiniMagick
    # Gives a nifty method to reduce the final image footprint.
    # @param percentage -> integer (1..100)
    # returns image
    # quality(80) => <#Image:xxxxx.....>
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end

    # If any of the image dimension exceeds 8000 px, rejects the image by raising
    # CarrierWave::ProcessingError and error message 'dimensions too large'.
    # This helps in reducing the chances of any ddos attacks through pixel flooding.
    def validate_dimensions
      manipulate! do |img|
        if img.dimensions.any? { |i| i > 8000 }
          raise CarrierWave::ProcessingError, 'dimensions too large'
        end
        img
      end
    end
  end
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
