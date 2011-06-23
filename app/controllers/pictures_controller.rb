class PicturesController < ApplicationController

	  # The picture controller deals with the CRUD of images and their metadata.  These images can be anything, but are 
  # generally Tree images.
  
  
  def index
    # TODO Paging wont work because PictandMeta is not an ActiveModel
    @tree_id = params[:assigned_pics_tree].to_s if params[:assigned_pics_tree]
    @pictures = Picture.all
  end
  
  def show
  	@picture = Picture.find(params[:id])
  end
  
  def new
    session[:assigned_pics_tree] = {:tree => [params[:assigned_pics_tree].to_s]} if params[:assigned_pics_tree]
  	@picture = Picture.new
  end
  
  def edit
    @picture = Picture.find(params[:id])
  end
  
  def update
    @picture = Picture.find(params[:id])
    if @picture.update_attributes(params[:picture])
      flash[:notice] = "Successfully updated Picture."
      redirect_to pictures_url
    else
      render :action => 'edit'
    end
  end
  
  def create
  	@picture = Picture.new(params[:picture])
    if @picture.save
      flash[:notice] = "Successfully created picture."
      redirect_to @picture
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @picture = Picture.find(params)
    if @picture.destroy
      flash[:notice] = "Successfully destroyed picture."
      redirect_to pictures_url
    else 
      flash[:notice] = "Error in the delete"
      redirect_to pictures_url
     end
  end
  
 #  Collection resource methods here
  
  # gets involved from index when the user has requested to associate pictures with specific trees
  # uses a hidden field called selected_tree to hold the tree id.
  # add_to[pic_id] is an input field that contains an array of picture Ids
  def selected_trees
    Rails.logger.info(">>>Selected Tree #{params.inspect}")
    if Picture.add_assigned_pics(params['selected_tree'], params['add_to'])
      flash[:notice] = "Successfully added selected pictures."
    else
      flash[:notice] = "Pictures not added due to error."
    end
    redirect_to :controller => 'trees', :action => 'show', :id => params['selected_tree']
  end
  

  # A PUT Resource that is called, currently, to remove a tree reference from a Picture.
  # IN: id of picture, id of tree
  def assignedtrees
    @pictures = Picture.find(params)
    @pictures.delete_assigned_pics(params[:tree])
    redirect_to :controller => 'trees', :action => 'show', :id => params[:tree]
  end

  # This is basically an algorithm resource GET kinds/search
  def search
    # if the user has selected to clear the search, or there is no search params, start from the top
    Rails.logger.info("Pic Search: #{params.inspect}")
    if params[:clear] || params[:q] == ""
      redirect_to pictures_path
    else  
      @pictures = Picture.search(params[:q])
      #@page = 1
      render :index
    end
  end




end
