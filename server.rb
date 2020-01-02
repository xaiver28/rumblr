require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require './models'

set :port, 3000
set :database, {adapter: "sqlite3", database: "rumblr.sqlite3"}
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
  if user.password == given_password
    session[:user_id] = user.id
    redirect '/profile'
  else
    flash[:error] = "Correct email, but wrong password. Did you mean:
     #{user.password}? \
    Only use this password if that is your account."
    redirect "/login"
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
