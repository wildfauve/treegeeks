class SearchController < ApplicationController

	def show
		Rails.logger.info(">>>Search Controller>>index: #{params.inspect}")
	    @trees = Tree.search(params[:trees]).page params[:page]
	    Rails.logger.info(">>>Tree Controller>>SEARCH: #{@trees.count}")
    	respond_to do |format|
    		format.js
    	end
	end

end
