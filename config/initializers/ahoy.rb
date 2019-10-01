class Ahoy::Store < Ahoy::DatabaseStore
  def user
    controller.current_participant
  end
end

# set to true for JavaScript tracking
Ahoy.api = false
