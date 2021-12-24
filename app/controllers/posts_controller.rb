class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: [:destroy, :edit, :update]

  def show 
    @user = current_user if logged_in?
    @post = current_user.posts.find_by(id: params[:id])
  end

  def index 
    @user = current_user if logged_in?
  end

  def new
    @user = current_user
    @post_create = current_user.posts.build
  end
  
  def create
    @user = current_user
    @post_create = current_user.posts.build(post_params)
    if @post_create.save
      flash[:success] = "投稿しました！"
      redirect_to current_user
    else
      render "new"
    end
  end

  def edit
    @user = current_user
    @post = Post.find_by(id: params[:id])
  end

  def update
    @user = current_user
    @post = Post.find_by(id: params[:id])
    if @post.update(post_params)
      flash[:success] = "編集されました"
      redirect_to has_this_post(@post)
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy!
    flash[:success] = "削除されました"
    redirect_to has_this_post(@post)
  end

  private

    def post_params
      params.require(:post).permit(:title, :body)
    end

    def correct_user
      post = Post.find_by(id: params[:id])
      unless has_this_post?(post) || current_user.admin?
        flash[:danger] = "正しいユーザではありません"
        redirect_to has_this_post(post)
      end
    end
end
