module ApplicationHelper
  def additional_js
    js_tag = ""
    if @additional_js
      @additional_js.each do |js_file|
        js_tag += javascript_include_tag(js_file)
      end 
    end
    js_tag.html_safe
  end
end
