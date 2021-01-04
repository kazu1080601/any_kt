# テーブル設計

## usersテーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| nickname           | string     | null: false                    |
| email              | string     | null: false                    |
| encrypted_password | string     | null: false                    |
| prefecture_id      | integer    | null: false                    |
| city               | string     | null: false                    |

### Association
- has_many   :valuations
- belongs_to :prefecture


## valuationsテーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| comment            | text       | null: false                    |
| date               | date       | null: false                    |
| genre_id           | integer    | null: false                    |
| place_id           | string     | null: false                    |
| user               | references | foreign_key: true              |

### Association
- belongs_to :user
- has_many   :valuation_recommends
- belongs_to :genre


## valuation-recommendsテーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| valuation          | references | foreign_key: true              |
| recommend_id       | integer    | null: false                    |

### Association
- belongs_to :valuation
- belongs_to :recommend