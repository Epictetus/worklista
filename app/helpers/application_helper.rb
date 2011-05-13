module ApplicationHelper
  include Rack::Recaptcha::Helpers

  def title(page_title)
    content_for(:title) { page_title }
  end

  def login_link
    if user_signed_in?
      "Hi, #{current_user.username}! | " +
        "#{link_to 'Setting', '/edit'} | " +
        "#{link_to 'Logout', '/logout'}"
    else
      "#{link_to 'Login', '/login'} | " +
        "#{link_to 'Sign up', '/signup'}"
    end
  end

  def link_to_hatena(url)
    base_url = "http://b.hatena.ne.jp/entry/"
    if url =~ /^(http:\/\/)(.+)/
      target = $2
    else
      target = ""
    end
    base_url + target 
   end

  def truncstr(str, size)
    # Considering the width of the displayed string since a Japanese
    # character takes twice the width as alphanumeric.
    return str if str.size <= size
    truncated = str[0, size]
    non_alphanum = truncated.gsub(/[\w\s\d]/, '')
    extra_space = (truncated.size - non_alphanum.size) / 2
    if str.size <= size + extra_space
      str
    else
      str[0,size + extra_space] + "..."
    end
  end

  # We need this for atom_feed since an item doesn't have its
  # correspoding show page
  def item_url(item)
    item.url
  end

  def feed_tag
    url_options = Rails.env.production? ? {:host => "worklista.com"} : {:host => "localhost:3000"}
    content_for(:feed) { auto_discovery_link_tag(:atom, url_options) }
  end
end
