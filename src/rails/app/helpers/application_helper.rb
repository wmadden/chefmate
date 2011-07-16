module ApplicationHelper

  def current_tab?( tab_name )
    @current_tab == tab_name ? "current" : ""
  end

end
