class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  #def index
  #  @movies = Movie.all
  #end

  def index
    sorting = params[:sort] || session[:sort]
    @all_ratings = Movie.all_ratings
    ticked_ratings_history = params[:ratings] || session[:ratings]
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sorting
      session[:ratings] = ticked_ratings_history
      redirect_to :sort => sorting, :ratings => ticked_ratings_history and return
    end    
    
    flash.keep
    @ratings = ticked_ratings_history.nil? ? Movie.all_ratings : ticked_ratings_history.keys
    @movies = Movie.order(sorting).where(:rating => @ratings).all
    
  end 


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
