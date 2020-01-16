class CrowdaiMigrationController < ApplicationController
  def setup
    @data = params[:data]
    @cid  = crowdai_params[:id]
    redirect_to(root_path, flash: { error: 'Missing data' }) if @cid.nil?
  end

  def save
    redirect_to(root_path, flash: { error: 'Error while processing, contact help@aicrowd.com' }) && return if @cid.nil?

    @migrate_service = MigrateUserService.new(crowdai_id: @cid, aicrowd_id: current_participant.id)

    redirect_to(root_path, flash: { error: 'Participant Already Migrated' }) && return if @migrate_service.check_migrated

    redirect_to(root_path, flash: { error: 'No Data exists for this user' }) && return unless MigrationMapping.exists?(crowdai_participant_id: @cid)

    MigrateUserJob.perform_later(crowdai_id: @cid, aicrowd_id: current_participant.id)

    redirect_to(root_path, flash: { success: 'Migration in progress.' })
  end

  def crowdai_params
    @crowdai_params ||= begin
                          return {} unless @data

                          rsa_key                   = OpenSSL::PKey::RSA.new(ENV['CROWDAI_PARTICIPANT_MIGRATION_PUBKEY'])
                          cipherkey, iv, ciphertext = @data.split('~').map { |x| Base64.urlsafe_decode64(x) }
                          cipher                    = OpenSSL::Cipher.new('AES-256-CBC')
                          cipher.decrypt
                          cipher.key = rsa_key.public_decrypt(cipherkey)
                          cipher.iv  = iv
                          plaintext  = cipher.update(ciphertext) + cipher.final
                          JSON.parse(plaintext).symbolize_keys
                        rescue StandardError => e
                          puts e.backtrace
                          {}
                        end
  end
end
