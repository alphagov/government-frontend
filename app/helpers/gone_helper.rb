module GoneHelper
  def alternative_path_link(request, alternative_path)
    alternative_url = File.join(request.protocol, request.host, alternative_path)
    link_to(alternative_url, alternative_path, class: "govuk-link")
  end
end
