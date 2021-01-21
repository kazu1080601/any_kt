# アプリケーション名
## any!

# アプリケーション概要

## コンセプト
あなたの「何でもいい」をサポート

## アプリケーションの機能
- 指定した場所周辺の施設を、ジャンルやキーワードを指定して検索（Google Maps API）
- 施設名およびポジティブワード（「おすすめ」など）をキーワードとして、ツイート検索（TwitterAPI）
- 検索結果の店舗を選択し、簡単にコメントを保存

# URL
https://anykt.herokuapp.com/

# テスト用アカウント
## ユーザー名
test@test
## パスワード
test1234

# 利用方法
- 画面上部の入力欄に、以下の情報を入力する。
  - 周辺検索をしたい場所
  - Twitter検索時に、施設名と合わせて検索ワードに指定するポジティブワードを選択。各ワード選択時の検索文字列は以下の通り
    - おすすめ！：施設名 + 「おすすめ」or「オススメ」or「お勧め」
    - また行きたい！：施設名 + 「また行きたい」or「またいきたい」
    - 好き！：施設名 + 「好き」or「好み」
  - 施設のジャンル
  - キーワード（省略可）
  - 検索範囲（検索場所を中心とした範囲）
- 関連Tweetを検索したい場合は、「関連Tweet検索」をクリック。他のユーザーのコメントを検索する場合は「他ユーザーコメント検索」をクリック。
- 画面中央部の「検索結果」の欄に、ヒットしたTweet（コメント）数と店名が一覧される
- 店舗名をクリックすると、Tweet（コメント）が画面下部に一覧される
- 画面下部に表示された店名をクリックすると、店情報一覧およびコメントを記入できるページに遷移する
- コメントの他に、ポジティブワードの選択、写真のアップロードが可能。

# 目指した課題解決
## 想定するユーザー
好き嫌いがあまりなく、どこでも（何でも）ある程度楽しめる人
## ユーザーの課題
- 行きたいところのストックが無いので、おすすめの場所をさくっと調べたい！
- なるべくタイムリーな情報が欲しい！

# 洗い出した用件
- 指定場所周辺検索：googlemapのAPIを使用して、指定した範囲の指定場所周辺施設を検索し、リストアップする
- twitter検索：TwitterAPIを使用し、対象の施設について、「おすすめ」というワードが入ったツイートを検索して、一覧する。（検索ワードは、後で選択式に変更する）
- 周辺施設とツイートの照合：施設ごとに、上記で検索したツイートを紐付け、一覧表示できるようにする
- 施設ジャンル指定：グルメやレジャーなど、ジャンルを指定することで、行きたい施設を絞りやすくする
- 施設コメント機能：行った日、感想を残せるようにする
- 施設写真貼付機能：写真を残せるようにする。可能であれば複数枚の添付に対応する
- ユーザー登録機能：評価した情報をユーザーに紐付けて残すために、ユーザー情報を管理する。
- twitter検索ワード変更（最初は「おすすめ」のみ）：基本的には「おすすめ」で検索するが、「また行きたい」や「好き」といったポジティブワードも選べるようにする。（手軽に使いたいので、テキストを入力するような仕組みにはしない）
- 施設評価機能：「twitter検索ワード変更」と同様に、「おすすめ」「また行きたい」「好き」といったワードを選択して評価できるようにする
- 他のユーザーの評価検索機能：ツイートとは別に、他のユーザーの評価情報を閲覧できるようにする
- 現在地周辺検索：googlemapのAPIを使用して、指定した範囲の現在値周辺施設を検索し、リストアップする
- 地図上にツイート数の表示：施設ごとに、ツイート数をカウントして地図上に表示

# GIF
## Tweetの検索
https://gyazo.com/7cd5de6d0309695299d87d75170914b4
## 検索結果からコメント入力ページに遷移
https://gyazo.com/9cc70d65be2f508be197faf5c4e38161
## 他のユーザーのコメント検索
https://gyazo.com/739a940c67085dfd14a454658dc14367

# 実装予定の機能
- 現在地周辺検索
- 地図上にツイート数の表示
- Tweet検索精度の向上


# テーブル設計
ER図：~/ER.dio

## usersテーブル

| Column             | Type       | Options                             |
| ------------------ | ---------- | ----------------------------------- |
| nickname           | string     | null: false                         |
| email              | string     | null: false                         |
| encrypted_password | string     | null: false                         |
| prefecture_id      | integer    | null: false                         |
| city               | string     |                                     |

### Association
- has_many   :valuations
- belongs_to :prefecture


## valuationsテーブル

| Column             | Type       | Options                             |
| ------------------ | ---------- | ----------------------------------- |
| comment            | text       | null: false                         |
| date               | date       | null: false                         |
| genre_id           | integer    | null: false                         |
| place_id           | string     | null: false                         |
| recommendation_id  | integer    | null: false                         |
| latitude           | decimal    | null: false, precision:10, scale:7  |
| longitude          | decimal    | null: false, precision:10, scale:7  |
| user               | references | foreign_key: true                   |

### Association
- belongs_to :user
- belongs_to :valuation
- belongs_to :genre

# ローカルでの動作方法
- git clone
- ターミナルで「bundle install」を実施
- ターミナルで「rails db:migrate」を実施

# 環境
- OS: macOS Big Sur バージョン11.1
- Ruby: ruby 2.6.5p114
- RubyGems: 3.0.3
- Rails: Rails 6.0.3.4
- MySQL: mysql  Ver 14.14 Distrib 5.6.50, for osx10.15 (x86_64) using  EditLine wrapper
- Git: git version 2.24.3 (Apple Git-128)
- heroku: heroku/7.47.6 darwin-x64 node-v12.16.2