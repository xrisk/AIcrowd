module ApplicationHelper

  def rewrite_type(key)
    case key
      when 'notice'
        'success'
      when 'success'
        'success'
      when 'info'
        'info'
      when 'alert'
        'warning'
      when 'error'
        'warning'
      when 'flash'
        'flash'
    end
  end

  def body_id
    if (controller.controller_name == 'landing_page' &&
          controller.action_name == 'index') ||
       (controller.controller_name == 'blogs' &&
          controller.action_name == 'index')
      return 'home'
    else
      return nil
    end
  end

  def footer_class
    if controller.controller_name == 'registrations' ||
       (controller.controller_name == 'challenges' && controller.action_name == 'edit') ||
       (controller.controller_name == 'organizers' && controller.action_name == 'edit') ||
       (controller.controller_name == 'sessions')
          return "class='no-margin-top'"
    else
      return nil
    end
  end

  def themed_button(opts = {})
    raise ArgumentError if opts.key?(:link) && opts.key?(:modal)
    title = opts[:title].presence || '&nbsp;'.html_safe
    link = opts[:link] unless opts[:disabled]
    modal = opts[:modal] unless opts[:disabled]

    outer = {}
    outer[:class] = opts[:class] if opts[:class]
    if link
      outer_type = :a
      outer[:href] = link
    else
      outer_type = :span
    end
    if opts[:tooltip]
      outer.merge!({
        title: opts[:tooltip],
        data: {
          toggle: 'tooltip',
        },
      })
    end

    inner = {
      type: 'button',
      disabled: opts[:disabled],
      class: "btn btn-secondary#{ ' btn-sm' if opts[:small] }",
    }
    if modal
      inner.merge!({
        data: {
          toggle: 'modal',
          target: modal,
        },
      })
    end

    content_tag(outer_type, outer) { button_tag(title, inner) }
  end
end
