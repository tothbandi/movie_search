class MovieSearchesController < ApplicationController
  def new; end

  def index
    data = MoviesClient.search(permitted_params[:keywords], permitted_params[:page])
    response = data[:response]
    result = JSON.parse(response.body)
    if response.code == '200'
      @keywords = permitted_params[:keywords]
      @movies = result['results']
      @count = data[:counter].to_i
      @cached = data[:cached]
      @page = result['page'].to_i
      @pages = result['total_pages'].to_i
      info = "Info downloaded from #{@cached ? 'CACHE' : 'TMDB'}."
      flash[:notice] = info
    else
      flash[:notice] = "3rd party API message: #{result['status_message']}"
    end
    render :new
  end

  private

  def permitted_params
    params.permit(:keywords, :page)
  end
end