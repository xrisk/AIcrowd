module Images
  class Base64DecodeService < ::BaseService
    DEFAULT_FILE_NAME       = 'base64_upload'.freeze
    SUPPORTED_CONTENT_TYPES = /gif|jpeg|png/.freeze

    def initialize(base64_data:)
      @base64_data = base64_data
    end

    def call
      return failure('Invalid data provided') unless base64_data.is_a?(String)

      temp_file    = prepare_temp_file_object(base64_data)
      # Read content_type from file meta data
      content_type = `file --mime -b #{temp_file.path}`.split(';').first
      extension    = content_type.match(SUPPORTED_CONTENT_TYPES).to_s

      return failure('Not supported content type') if extension.blank?

      uploaded_file = ActionDispatch::Http::UploadedFile.new(
        tempfile:     temp_file,
        content_type: content_type,
        filename:     "#{DEFAULT_FILE_NAME}.#{extension}"
      )

      success(uploaded_file)
    end

    private

    attr_reader :base64_data

    def prepare_temp_file_object(base64_string)
      temp_file = Tempfile.new(DEFAULT_FILE_NAME)

      temp_file.binmode
      temp_file.write(Base64.decode64(base64_string))
      temp_file.rewind

      temp_file
    end
  end
end
