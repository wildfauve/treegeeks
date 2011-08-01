class SearchController < ApplicationController

	def show
		if params[:trees].present?
			Rails.logger.info(">>>Search Controller>>show: #{params.inspect}")
		   @trees = Tree.search(params[:trees]).page params[:page]
		   Rails.logger.info(">>>Tree Controller>>SEARCH: #{@trees.count}")
	    	respond_to do |format|
	    		format.js
	    	end
	   end
	end

end
