#encoding : utf-8
%w(rubygems bundler).each { |dependency| require dependency }
Bundler.setup
%w(sinatra oauth sass json weibo mysql).each { |dependency| require dependency }
enable :sessions
Weibo::Config.api_key = "2942145647"
Weibo::Config.api_secret = "5cc0026c470a25a6070237e07ade5f27"

class HomeController < ApplicationController
  def index
    if session[:atoken]
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(session[:atoken], session[:asecret])
      #@timeline = Weibo::Base.new(oauth).friends_timeline
      #Weibo::Base.new(oauth).upload(CGI::escape("测试"),File.new("d:\\1.jpeg","rb"))
      @session1 = session[:atoken]
      @session2 = session[:asecret]
    end
  end
  
  def callback
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
    session[:rtoken], session[:rsecret] = nil, nil
    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
    session[:userid] = oauth.access_token
    redirect_to "/home/index"
  end
  
  def connect
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    request_token = oauth.consumer.get_request_token
    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
    #session[:rtoken], session[:rsecret], session[:user_id] = request_token.token, request_token.secret, request_token.userid
    redirect_to "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/home/callback"
  end

end
