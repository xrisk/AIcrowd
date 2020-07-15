module SearchHelper
  def search_pills_active_class(pill_type, type)
    'active' if pill_type == type
  end
end
