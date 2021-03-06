class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :play]
  helper_method :sort_column, :sort_direction

  # GET /movies
  # GET /movies.json
  def index
    @movies = PlatformMovie.current.sort { |a, b| b.meta_score <=> a.meta_score }.collect do |movie|
      {
        image_url: movie.movie.image_url,
        platform_link: movie.platform_link,
        platform: (movie.type == 'HboMovie') ? 'hbo' : 'Showtime',
        meta_score: movie.meta_score,
        youtube: movie.movie.youtube,
        title: movie.movie.title,
        summary: movie.movie.summary,
        rating: movie.movie.rating,
        year: movie.movie.year,
        created_at: movie.started
      }
    end
  end

  def latest
    @movies = PlatformMovie.latest
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render action: 'show', status: :created, location: @movie }
      else
        format.html { render action: 'new' }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def play
    @movie.play!
    render json: {}, status: :ok
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end

  def tweet_update
    if current_admin_user.present?
      PlatformMovie.find(params[:id]).notify!
      redirect_to admin_dashboard_path
    else
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.where(hbo_id: params[:hbo_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :summary, :year, :imdb_link, :image, :rating, :hbo_id)
    end

end
