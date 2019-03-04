if Rails.env.test? || Rails.env.development?
  class DiscourseApi::Client
    def create_category(options={})
      return {id: 1}
    end

    def update_category(options={})
      return {id: 1}
    end
  end
end
