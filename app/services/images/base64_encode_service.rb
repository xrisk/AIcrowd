module Images
  class Base64EncodeService < ::BaseService
    SUPPORTED_CONTENT_TYPES = /gif|jpeg|png|svg/.freeze

    def initialize(image_url:)
      @image_url = image_url
    end

    def call
      return failure('URL is invalid') unless valid_url?

      image_file = open(@image_url)

      return failure('Not supported content type') if image_file.content_type.match(SUPPORTED_CONTENT_TYPES).blank?

      base64_string = Base64.encode64(image_file.read)

      success(base64_string)
    rescue OpenURI::HTTPError => e
      return failure('There is no image under provided URL') if e.message == '404 Not Found'
      return failure('Image under provided URL is forbidden') if e.message == '403 Forbidden'

      raise e
    end

    private

    attr_reader :image_url

    def valid_url?
      url = begin
              URI.parse(image_url)
            rescue StandardError
              false
            end
      url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
    end
  end
end
