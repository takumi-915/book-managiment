class PostsController < ApplicationController
  before_action :move_to_index, except: [:index, :show, :search, :menu]
  
  def index
    @posts = Post.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    begin
      @post.save!
    rescue ActiveRecord::RecordInvalid => e
      puts e
    end
    redirect_to menu_posts_path
  end

  def show
    @post = Post.find(params[:id])
  end

  def search
    @post = Post.search(params[:keyword])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update(post_params)
    redirect_to post_path(post.id)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to menu_posts_path
  end

  def menu
    @posts = Post.all.order("created_at DESC").page(params[:page]).per(9)
  end

  private
  def post_params
    params.require(:post).permit(:title, :review, :content, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

end