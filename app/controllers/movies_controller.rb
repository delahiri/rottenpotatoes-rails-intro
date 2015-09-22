class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

        @allRatingType = Movie.all_ratings

        if(session[:ratings] == nil and session[:sort]== nil)
          sessionIsEmpty = true
        end

        if(params[:ratings] != nil)
          session[:ratings] = params[:ratings]
        else
          ratingIsEmpty = true
        end
        if(params[:sort] != nil)
          session[:sort] = params[:sort]
        else
          sortIsEmpty = true
        end

        params[:ratings] = session[:ratings]
        params[:sort] = session[:sort]

        if(params[:ratings] != nil)
          @sel_ratings =params[:ratings].keys
        else
          @sel_ratings =Movie.all_ratings
        end

        if(params[:sort]=='title')
          if (params[:ratings] )
            @movies = Movie.where("rating in (?)", @sel_ratings).order('title')
          else
            @movies = Movie.all.order('title')
            end
        elsif(params[:sort]=='release_date')
          if (params[:ratings])
            @movies = Movie.where("rating in (?)", @sel_ratings).order('release_date')
             else
            @movies = Movie.all.order('release_date')
          end
        else
          if (params[:ratings] )
            @movies = Movie.where("rating in (?)", @sel_ratings)
            else
          @movies = Movie.all
            end
        end
        @title_header = params[:sort]=='title' ?'hilite':nil
        @release_date_header = params[:sort]=='release_date' ?'hilite':nil

    if (ratingIsEmpty or sortIsEmpty) and !sessionIsEmpty
      redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    end




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
