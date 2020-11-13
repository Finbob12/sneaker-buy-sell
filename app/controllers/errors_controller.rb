class ErrorsController < ApplicationController

  #methods to render correct error pages depending on the routing conditions
  
  def not_found
    render(:status => 404)
  end

  def internal_server_error
    render(:status => 500)
  end
end
