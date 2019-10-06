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
  current_user.posts.create(budget: params[:budget]);
  redirect '/'
end

get '/posts/:id/edit' do
  @post = Post.find(params[:id],params[:budget])

  erb :edit
end

post '/posts/:id' do
  post = Post.find(params[:id])
  @cost = params[:cost]
  @budget = @budget - @cost
  post.save
  redirect "/posts/#{post.id}/edit"
end
