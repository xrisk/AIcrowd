require 'cgi'
require 'active_support'

class SessionService < ::BaseService
  def initialize(cookie)
    @cookie                  = CGI.unescape(cookie)
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
      result = encryptor.decrypt_and_verify(@cookie)
    rescue StandardError => e
      puts 'Error to descrypt'
    end
    if result.present? && !result['warden.user.participant.key'].nil?
      success(result)
    else
      failure('Fail to decrypt and verify cookie.')
    end
  end
end
