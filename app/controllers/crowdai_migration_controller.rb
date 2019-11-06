class CrowdaiMigrationController < ApplicationController
  before_action :authenticate_participant!
  before_action :ensure_valid_cid


  def migrate_user
    MigrateUserService(crowdai_id: @cid, aicrowd_id: current_participant.id).call
    redirect_to(root_path, flash: {success: 'Migration in progress.'})
  end

  def crowdai_params
    @crowdai_params ||= begin
      rsa_key = OpenSSL::PKey::RSA.new(ENV['CROWDAI_PARTICIPANT_MIGRATION_PUBKEY'])
      cipherkey, iv, ciphertext = params[:data].split('~').map { |x| Base64.urlsafe_decode64(x) }
      cipher = OpenSSL::Cipher.new('AES-256-CBC')
      cipher.decrypt
      cipher.key = rsa_key.public_decrypt(cipherkey)
      cipher.iv = iv
      plaintext = cipher.update(ciphertext) + cipher.final
      JSON.parse(plaintext).symbolize_keys
    rescue
      {}
    end
  end

  private def ensure_valid_cid
    @cid = crowdai_params[:id]

    if @cid.nil? || !MigrationMapping.exists?(crowdai_participant_id: @cid)
      redirect_to(root_path, flash: {error: 'Unknown crowdAI participant ID'})
    end

    if MigrationMapping.exists?(crowdai_participant_id: @cid, source_type: 'Participant')
      redirect_to(root_path, flash: {error: 'Participant Already Migrated'})
    end
  end
end
