class RecommendationsController < ApplicationController
  def index
    return_list = get_db(params[:search_list])
    # return_list = get_tweet(params[:search_list])
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
    shop_valuation = get_valuation(params[:shop_name])
    shop_info = { name: "#{params[:shop_name][:name]}", place_id: "#{params[:shop_name][:id]}"}
    shop_name_valuation = shop_valuation.to_a.unshift(shop_info)  # 店名を追加するために、ActiveRecord_Relationクラスを配列に変換し、先頭に店名とplace_idを追加
    render json: { shopNameValuation: shop_name_valuation } unless shop_valuation == nil
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

    # Twitter検索ワードを抽出
    search_word = ""
    (Recommendation.all.length - 1).times do |i|
      if search_list["search_id"].to_i == i + 2
        search_word = Recommendation.all.find(i + 2).search
      end
    end
    # 抽出したらTwitter検索ワードをハッシュから削除
    search_list.delete("search_id")

    response_hash = {}

    search_list.each_value do |name|

      # ツイート検索のクエリを設定（-is:retweet=>リツイートは除く  -is:quote=>引用ツイートは除く  -has:links=>リンクを含むツイートは除く）
      query = "(#{name.gsub(' ', ' OR ')}) #{search_word} -is:retweet -is:quote -has:links"
      puts query

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
        response_hash.store(name,JSON.parse(response.body)["data"])
        response_hash[name].each do |data|
          data.delete("id")
        end
      end
    end
    return response_hash
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

  def get_db (search_list_params)
    return if search_list_params == nil

    # paramsに含まれる「place_id」をハッシュとして取出
    search_list = search_list_params.to_unsafe_h

    # DBからデータを抽出
    valuations = Valuation.all   #いらない？要修正！

    response_hash = {}
    search_list.each do |place|
      hit_num = Valuation.where(place_id: "#{place[1]}").length  # place[0]に店名が、place[1]にplace_idが入っている
      response_hash.store("#{place[0]}", hit_num)
    end

    return response_hash
  end

  def get_valuation (shop_name)
    shop_valuation = Valuation.where(place_id: "#{shop_name["id"]}")
    return shop_valuation
  end

  def valuation_params
    params.require(:valuation).permit(:image, :comment, :date, :genre_id, :place_id, :recommendation_id, :latitude, :longitude).merge(user_id: current_user.id)
  end


end
