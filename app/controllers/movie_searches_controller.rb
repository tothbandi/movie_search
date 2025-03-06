class MovieSearchesController < ApplicationController
  def new; end

  def index
    data     = MoviesClient.search(permitted_params[:keywords], permitted_params[:page])
    response = data[:response]
    result   = JSON.parse response.body

    if response.code == "200"
      @keywords = permitted_params[:keywords]
      @movies   = result["results"]
      @count    = data[:counter].to_i
      @cached   = data[:cached]
      @page     = result["page"].to_i
      @pages    = result["total_pages"].to_i

      flash[:notice] = info @count, @cached
    else
      flash[:notice] = "3rd party API message: #{ result['status_message'] }"
    end
    render :new
  end

  private

  def permitted_params
    params.permit(:keywords, :page)
  end

  def info(count, cached)
    source = "TMDB"
    source = "CACHE #{ @count } time(s)" if @cached
    "Info downloaded from #{ source }."
  end
end
