class NetworksController < ApplicationController
  before_action :set_network, only: [:show, :edit, :update, :destroy]

  include NetworksHelper

  # GET /networks
  # GET /networks.json
  def index
    @networks = Network.all
  end

  # GET /networks/1
  # GET /networks/1.json
  def show
    @network = Network.find(params[:id])
    if params[:query]
      @posts = @network.search_posts(params[:query])
      @avg_likes = get_search_stats(@posts, @network, "likes")
      @avg_comments = get_search_stats(@posts, @network, "comments")
      @avg_shares = get_search_stats(@posts, @network, "shares")
      @avg_engagement = get_search_stats(@posts, @network, "engagement")
    else
      @posts = @network.posts
      @avg_likes = 0
      @avg_comments = 0
      @avg_shares = 0
      @avg_engagement = 0.00000
    end

    if params[:order] 
      if params[:order] == "DESC"
        @order = "ASC"
      else
        @order = "DESC"
      end
    else
      @order = "DESC"
    end


    if params[:filter]
      @posts = sort_posts(@posts, params[:filter], @order)
    else
      @posts = sort_posts(@posts, "date", @order)
    end

    @posts = @posts.paginate(:page => params[:page], :per_page => 25)


    
  #Bringing up some metrics for engagement
    @imp = (0.05 * @network.fb_fans.to_f)
  end

  # GET /networks/new
  def new
    @network = Network.new
  end

  # GET /networks/1/edit
  def edit
  end

  # POST /networks
  # POST /networks.json
  def create
    @network = Network.new(network_params)


    respond_to do |format|
      if @network.save
        format.html { redirect_to @network, notice: 'Network was successfully created.' }
        format.json { render action: 'show', status: :created, location: @network }
      else
        format.html { render action: 'new' }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /networks/1
  # PATCH/PUT /networks/1.json
  def update
    respond_to do |format|
      if @network.update(network_params)
        format.html { redirect_to @network, notice: 'Network was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.json
  def destroy
    @network.destroy
    respond_to do |format|
      format.html { redirect_to networks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_network
      @network = Network.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def network_params
      params.require(:network).permit(:fb_id, :name, :fb_fans, :logo)
    end


end
