require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require './models'
require 'pg'

configure :development do
set :database, { adapter: 'postgresql',
                 database: 'rumblr',
                 username: 'postgres',
                 password: ENV['POSTGRES_PW']}
end


configure :production do
  set :database, {url: ENV['DATABASE_URL']}
end



enable :sessions


get '/' do
  erb :home
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @user = User.new(params[:user])

  if @user.valid?
    @user.save
    redirect '/profile'
  else
    flash[:error] = @user.errors.full_message
    redirect '/signup'
  end
  p params
end


get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(email: params[:email])
  given_password = params[:password]
if @user.valid?
  # @user.save
  if user.password == given_password
    session[:user_id] = user.id
    redirect '/profile'
  else
    flash[:error] = "Invalid Email or Password"
    redirect "/login"
  end

end

end


get '/profile' do
  if session[:user_id] == nil
    redirect '/login'
  else
  # @user=User.find(params[:email])
  erb :profile
end
end

get '/logout' do
  session[:user_id] = nil
  # erb :logout
  redirect '/login'
  "You are now logged out"
end

get '/blogs' do
  erb :blogs
end

get '/show' do
  @posts = Post.order(created_at: :desc).all
  erb :show
end

post '/blogs' do
  @post= Post.new(title: params[:blog]['title'], content: params[:blog]['content'],user_id: session[:user_id])
  if @post.valid?
    @post.save
    redirect '/show'
  else
    erb :profile
end
end
