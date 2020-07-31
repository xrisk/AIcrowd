module ErrorHelper
  def pretty_error_code(code)
    chars        = code.to_s.split('')
    html_content = if chars.length == 3 && chars[1] == '0'
                     <<~HTML
                       <span class="display-1">#{chars[0]}</span>
                       <div class="logomark"></div>
                       <span class="display-1">#{chars[2]}</span>
                     HTML
                   else
                     <<~HTML
                       <span class="display-1">#{code}</span>
                     HTML
    end

    sanitize_html(html_content)
  end
end
