module TwitterBootstrapHelper
  def tb_icon(icon_name, text = "", options = {})
    text = " "+text if !text.blank?
    options[:class] ||= "icon-"+icon_name
    content_tag(:i, "", options)+text
  end

  def tb_navbar_dropdown(title)
    content_tag :li, :class => "dropdown" do
      raw(content_tag(:a, {:href => "#", :class => "dropdown-toggle", "data-toggle" => "dropdown"}) do
        concat(title)
        concat " "
        concat(content_tag :b, "", :class => "caret")
      end)+
      raw(content_tag(:ul, nil, {:class => "dropdown-menu"}) do
        yield
      end)

    end
  end

  def tb_nav_link(title, url)
    content_tag :li do
      link_to title, url
    end
  end
end
