module ApplicationHelper

  def render_errors(obj)
    ret = ""

    if obj.errors.any?

      ret += "<ul>"

      obj.errors.full_messages.each do |msg|
        ret += "<li>#{msg}</li>"
      end

      ret += "</ul>"

    end
    ret.html_safe
  end
  
end
