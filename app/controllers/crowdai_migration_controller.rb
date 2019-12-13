class CrowdaiMigrationController < ApplicationController
  before_action :authenticate_participant!

  def setup
  end

  def save
    @cid = crowdai_params[:id]

    if @cid.nil?
      redirect_to(root_path, flash: {error: 'Unknown crowdAI participant ID'}) and return
    end

    @migrate_service = MigrateUserService.new(crowdai_id: @cid, aicrowd_id: current_participant.id)

    if @migrate_service.check_migrated
      redirect_to(root_path, flash: {error: 'Participant Already Migrated'}) and return
    end

    unless MigrationMapping.exists?(crowdai_participant_id: @cid)
      redirect_to(root_path, flash: {error: 'No Data exists for this user'}) and return
    end

    @migrate_service.migrate_user
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
end
