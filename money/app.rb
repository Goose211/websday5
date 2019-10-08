require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end

before '/posts' do
  if current_user.nil?
    redirect '/'
  end
end

get '/' do
if current_user.nil?
  @posts = Post.none
else
  @posts = current_user.posts
  @budget = params[:budget]
  @cost = params[:cost]
  @plus =  current_user.posts.where(task: 'true').count
  @minus = current_user.posts.where(task: 'false').count
  @cost = current_user.posts.all.sum(:cost)
  @total = current_user.posts.all.sum(:total)
  @fin = @cost-@total
end
  erb :index
end


get '/signup' do
  erb :sign_up
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

post '/signup' do
  @user =User.create(name:params[:name],password:params[:password],password_confirmation:params[:password_confirmation])
  if @user.persisted?
    session[:user] = @user.id
end
redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

post '/posts' do
  current_user.posts.create(total: params[:total]);
  #post = Post.find(params[:id]).max
  #redirect "/posts/#{post.id}/edit"
  redirect '/'
end

get '/posts/:id/edit' do
  @post = Post.find(params[:id],params[:total])

  erb :edit
end

post '/posts/:id' do
  post = Post.find(params[:id])

  post.cost = params[:cost]
  post.total = post.total-post.cost
  post.save
  redirect "/posts/#{post.id}/edit"
end


get '/posts/:id/result' do

  @post = Post.find(params[:id],params[:total])
  # 値に応じてコメントが変わる機能
  erb :result
end




post '/posts/:id/done' do
  post = Post.find(params[:id])
  if post.total < 0
  post.task = false
else
  post.task = true
end
  post.completed = true
  post.save
  redirect "/"
end
