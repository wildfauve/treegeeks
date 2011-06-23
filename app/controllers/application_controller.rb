class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def set_domain(domain_name)
  	@domain_name = domain_name
  end
end
