module MollioHelper

  def start_form_tag(url_for_options = {}, options = {}, *parameters_for_url, &proc)
    options[:class] = "f-wrap-1"
    super(url_for_options, options, *parameters_for_url, &proc)
  end

  def field_label(label, id, required = true)
    klass = ""
    if id.kind_of? Array
      object_name, method = id
      id = "#{object_name}_#{method}"
      object = instance_variable_get("@#{object_name}")
      if object && object.respond_to?("errors") && object.errors.respond_to?("on")
        if object.errors.on(method)
          klass = "error"
        end
      end
    end
    out = %(<label for="#{id}" class="#{klass}"><b>#{required ? %[<span class="req">*</span>] : ""}#{label}:</b>)
    out << yield if block_given?
    out << %(<br /></label>)
    out
  end

  def text_field_tag(name, value = nil, options = {})
    options["class"] = "f-name"
    super(name, value, options)
  end

  def password_field_tag(name, value = nil, options = {})
    options["class"] = "f-password"
    super(name, value, options)
  end

  def check_box_tag(name, value = "1", checked = false, options = {})
    options["class"] = "f-checkbox"
    super(name, value, checked, options)
  end

  def submit_tag(value = "Save changes", options = {})
    options["class"] = "f-submit"
    super(value, options)
  end

  def datetime_select(*p)
    o = super(*p)
    %!<span class="date_time">#{o}</span>!
  end

  def submit_row()
    out = %(<div class="f-submit-wrap">)
    out << yield
    out << %(<br /></div>)
  end

  def build_menu(menu, first = true)

    #TODO: add support for :url-less menu items
    #TODO: hide url-less menu items if none of their children are visible

    options_for_ul = {}
    options_for_ul[:id] = "nav" if first

    ul_body = ""

    menu.each_with_index { |item, i|

      if item[:visible] || item[:visible].nil?

        children_body = build_menu(item[:children], false) if item[:children]

        options_for_li = {}
        options_for_li[:class] = []
        options_for_li[:class] << "first" if i == 0
        options_for_li[:class] << "last" if i == (menu.length - 1)
        options_for_li[:class] << "active" if item[:selected]
        options_for_li[:class] = options_for_li[:class].join(" ")

        li_body = ""
        if item[:url].blank?
          li_body << link_to(item[:label], "#")
        else
          li_body << link_to(item[:label], item[:url])
        end
        li_body << children_body if item[:children]

        ul_body << "\n" << content_tag("li", li_body, options_for_li) << "\n" if item[:url] || (!item[:url] && item[:children].blank?) || !children_body.blank?

      end

    }

    out = ""

    out << content_tag("ul", ul_body, options_for_ul) << "\n" unless ul_body.blank?

    out
  end

  def build_breadcrumb(links)

    content_for_div = []

    links.each { |link|
      if link[:url]
        content_for_div << link_to(link[:label], link[:url])
      else
        content_for_div << content_tag("strong", link[:label])
      end
    }

    content_tag("div", content_for_div.join(" / "), {:id => "breadcrumb"})

  end

  def value_field_tag(value)
    content_tag "span", value, :class => "f-value"
  end

end