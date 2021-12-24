class Post < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :title, presence: true, length: {maximum: 30}
  validates :body, presence: true, length: {maximum: 3000}

  #keywordに一致する記事を返す
  def User.search(keyword)
    where(["title like? OR body like?", "%#{keyword}%", "%#{keyword}%"])
  end
end
