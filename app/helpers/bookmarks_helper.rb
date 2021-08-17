module BookmarksHelper
  def bookmark_link_id(post)
    "bookmark-link-#{post.class.to_s.downcase}-#{post.id}"
  end
end