class WebchatPresenter
  def initialize(base_path)
    @base_path = base_path
  end

  def webchat
    Webchat.find(base_path)
  end

  def heading_and_context
    {
      text: webchat.title,
      heading_level: 1,
      margin_bottom: 8,
      font_size: "xl",
    }
  end

  def webchat_body
    webchat.more_info_webchat
  end

  def csp_connect_src
    webchat.csp_connect_src
  end
end
