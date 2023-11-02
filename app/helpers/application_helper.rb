module ApplicationHelper
  include Pagy::Frontend

  def bootstrap_class_for(flash_type)
    {
      success: "text-green-700 bg-green-100",
      error: "text-red-700 bg-red-100",
      alert: "text-red-700 bg-red-100",
      recaptcha_error: "text-red-700 bg-red-100",
      notice: "text-blue-700 bg-blue-100"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:div, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger">
    #{messages}
    </div>
    HTML

    html.html_safe
  end

  def dataset_name(name)
    case name
    when "master"
      return 'Global Block'
    when "masteripes"
      return 'Global Block + IPES'
    when "masterverizon"
      return 'Global Block + Verizon + IPES'
    when "verizon"
      return 'Verizon + IPES'
    when "dnc"
      return 'DNC'
    when "ipes"
      return 'IPES'
    end

  end
end
