class RecommendationsController < ApplicationController
  def index
    return_list = get_tweet(params[:search_list])
    render json: { returnList: return_list} unless return_list == nil
  end

  def show
  end

  def new
    @shop_name = params[:shop_name]
    @place_id = params[:place_id]
    # @genre_id =
    @valuation = Valuation.new
  end

  def create
    @valuation = Valuation.new(valuation_params)
    if @valuation.save
      redirect_to root_path
    else
      render :new
    end
  end

  def search
    # @tweets = params[:result_show]
    # redirect_to recommendation_path
    # binding.pry
    # show
    # redirect_to root_path
    # binding.pry
    # render("recommendations/show")
    # (result_show: params[:result_show])
  end

  private

  def get_tweet (search_list_params)
    return if search_list_params == nil

    # TwitterAPIのサンプルコードに従い記述
    require 'json'
    require 'typhoeus'

    # ベアラートークンを設定
    bearer_token = ENV["BEARER_TOKEN"]

    # 「Recent Search API」のエンドポイントURL
    search_url = "https://api.twitter.com/2/tweets/search/recent"

    # paramsに含まれる検索ワードをハッシュとして取出
    search_list = search_list_params.to_unsafe_h

    response_arr = {}

    search_list.each_value do |name|

      # ツイート検索のクエリを設定（-is:retweet=>リツイートは除く  -is:quote=>引用ツイートは除く  -has:links=>リンクを含むツイートは除く）
      query = "(#{name.gsub(' ', ' OR ')}) おすすめ -is:retweet -is:quote -has:links"

      # クエリパラメータを設定
      # "tweet.fields"のpossiby_sensitiveは、ツイートにリンクが含まれる場合にのみ結果が表示される。
      query_params = {
      "query": query, # Required
      "max_results": 10,
      "tweet.fields": "text,geo",
      "place.fields": "geo,name,place_type"
      }

      response = search_tweets(search_url, bearer_token, query_params)
      # puts response.code, JSON.pretty_generate(JSON.parse(response.body))
      # 数値で比較すると条件分岐がうまく機能しないため、文字列に変換してから比較
      if JSON.parse(response.body)["meta"]["result_count"].to_s == "0"
      else
        response_arr.store(name,JSON.parse(response.body)["data"])
        response_arr[name].each do |data|
          data.delete("id")
        end
      end
    end
    return response_arr
  end

  def search_tweets(url, bearer_token, query_params)
    options = {
      method: 'get',
      headers: {
        "User-Agent": "v2RecentSearchRuby",
        "Authorization": "Bearer #{bearer_token}"
      },
      params: query_params
    }

    request = Typhoeus::Request.new(url, options)
    response = request.run

    return response

  end

  def valuation_params
    params.require(:valuation).permit(:image, :comment, :date, :genre_id, :place_id, :recommendation_id).merge(user_id: current_user.id)
  end


end
