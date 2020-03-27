class SessionService
  def initialize(cookie)
    @cookie                  = CGI::unescape(cookie)
    @secret_key_base         = Rails.application.secret_key_base
    @salt                    = 'authenticated encrypted cookie'
    @encrypted_cookie_cipher = 'aes-256-gcm'
    @serializer              = JSON
  end

  def call
    key_generator = ActiveSupport::KeyGenerator.new(@secret_key_base, iterations: 1000)
    key_len       = ActiveSupport::MessageEncryptor.key_len(@encrypted_cookie_cipher)
    secret        = key_generator.generate_key(@salt, key_len)
    encryptor     = ActiveSupport::MessageEncryptor.new(secret, cipher: @encrypted_cookie_cipher, serializer: @serializer)

    begin
      encryptor.decrypt_and_verify(@cookie)
    rescue Exception => error
      nil
    end
  end
end
