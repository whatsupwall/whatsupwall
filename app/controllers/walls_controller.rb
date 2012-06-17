class WallsController < ApplicationController
  before_filter :authenticate_user!, :except => [:display]

  # GET /walls
  # GET /walls.json
  def index
    @walls =  current_user.walls

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @walls }
    end
  end

  # GET /walls/1
  # GET /walls/1.json
  def show
    @wall = current_user.walls.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wall }
    end
  end

  def show_public_wall
    @wall = Wall.find_published_by_nickname_and_wall_name(params[:nickname], params[:name])
    if @wall
      render :layout => "public_wall"
    else
      render :layout => "non_valid_wall"
    end
  end

  # GET /walls/new
  # GET /walls/new.json
  def new
    @wall = Wall.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wall }
    end
  end

  # GET /walls/1/edit
  def edit
    @wall = current_user.walls.find(params[:id])
  end

  # POST /walls
  # POST /walls.json
  def create
    @wall = Wall.new(params[:wall])
    current_user.walls << @wall

    respond_to do |format|
      if @current_user.save
        format.html { redirect_to @wall, notice: 'Wall was successfully created.' }
        format.json { render json: @wall, status: :created, location: @wall }
      else
        format.html { render action: "new" }
        format.json { render json: @wall.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /walls/1
  # PUT /walls/1.json
  def update
    @wall = current_user.walls.find(params[:id])

    respond_to do |format|
      if @wall.update_attributes(params[:wall])
        format.html { redirect_to @wall, notice: 'Wall was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wall.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /walls/1
  # DELETE /walls/1.json
  def destroy
    @wall = current_user.walls.find(params[:id])
    @wall.destroy

    respond_to do |format|
      format.html { redirect_to walls_url }
      format.json { head :no_content }
    end
  end

  def publish
    @wall = current_user.walls.find(params[:id])
    @wall.update_attributes(:published => true)
    redirect_to wall_url
  end

  def unpublish
    @wall = current_user.walls.find(params[:id])
    @wall.update_attributes(:published => false)
    redirect_to wall_url
  end
end
