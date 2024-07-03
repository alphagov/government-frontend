module ComponentHelpers
  def component_name
    raise NotImplementedError, "Override this method in your test class"
  end

  def render_component(locals)
    render partial: "components/#{component_name}", locals:
  end
end
