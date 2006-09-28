module MollioSupport

  class PageInfo

    attr_accessor :template_base
    attr_accessor :title
    attr_accessor :site_name
    attr_accessor :menu
    attr_accessor :breadcrumb
    attr_accessor :copyright
  end

  def self.append_features(base)
    super
    base.helper "mollio"
    base.before_filter :setup_page_info
  end

  def add_breadcrumb(label, url)
    @page.breadcrumb << { :label => label, :url => url }
  end

  def select_menu(names, base = @page.menu)
    names = [names].flatten
    name = names.shift
    base.each { |m|
      m[:selected] = true if m[:label] == name
      select_menu(names, m[:children])
    } if base if name
  end

  def setup_page_info
    @page = PageInfo.new
    @page.template_base = "/mollio/"
    @page.title = "Title"
    @page.site_name = "Site Name"
    @page.copyright = "&copy; Some Company"
    @page.breadcrumb = []
    @page.menu = []
  end

end