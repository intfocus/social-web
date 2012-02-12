#encoding : utf-8
class HomeController < ApplicationController
  def index
    if user_signed_in?
      @number = Userkey.count_by_sql("select count(*) from userkeys where user_id='#{current_user.id}' and mail_user='#{current_user.email}'")
      if @number == 0
        redirect_to "/home/firm_weibo"
      end
    else
      
    end
    if session[:atoken]
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(session[:atoken], session[:asecret])
      @session1 = session[:atoken]
      @session2 = session[:asecret]
    end
  end
  
  def callback
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
    session[:rtoken], session[:rsecret] = nil, nil
    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
    if user_signed_in?
      save_user_key(current_user.id, current_user.email, "sinaweibo", session[:atoken], session[:asecret])
    end
    redirect_to "/home/index"
  end
  
  def connect
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    request_token = oauth.consumer.get_request_token
    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
    redirect_to "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/home/callback"
  end
  
  def firm_weibo
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def userinfo
    if user_signed_in?
      @struserinfo = UserInfo.find_by_user_id(current_user.id)
    else
      @struserinfo = UserInfo.find_by_user_id(1)
    end
  end
  
  def save_user_key(intuserid,strusermail,strwbfirm,strkey1,strkey2)
    Userkey.create(:user_id => intuserid, :mail_user => strusermail, :weibo_firm => strwbfirm, :key1 => strkey1, :key2 => strkey2)
  end
  
  def logout
    session[:atoken], session[:asecret] = nil, nil
    redirect_to "/"
  end
  
  def selected_display
    strtype = params[:type]
    strcode = params[:code]
    if(strtype == "userinfo") then
      if user_signed_in?
        @struserinfo = UserInfo.find_by_user_id(current_user.id).to_json
      else
        @struserinfo = UserInfo.find_by_user_id(1).to_json
      end
    end
    
    if(strtype == "province") then
      @struserinfo = ProvinceCity.find_all_by_ParentCode('CN').to_json
    end
    
    if(strtype == "city") then
      @struserinfo = ProvinceCity.find_all_by_ParentCode(strcode).to_json
    end
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def save_update
    strnickname = params[:nickname]
    strrealname = params[:realname]
    strpub_name_option = params[:pub_name_option]
    strprovince = params[:province]
    strcity = params[:city]
    strgender = params[:gender]
    strDate_Year = params[:Date_Year]
    strDate_Month = params[:Date_Month]
    strDate_Day = params[:Date_Day]
    strpub_birthday_option = params[:pub_birthday_option]
    strblog = params[:blog]
    strpub_blog = params[:pub_blog]
    strfavorite_email = params[:favorite_email]
    strpub_email_option = params[:pub_email_option]
    strqq = params[:qq]
    strred_qq = params[:red_qq]
    strmsn = params[:msn]
    strpub_msn_option = params[:pub_msn_option]
    strmydesc = params[:mydesc]
    struserinfo = UserInfo.find_by_user_id(1)
    struserinfo.update_attributes({
      :nick_name => strnickname,
      :real_name => strrealname,
      :province => strprovince,
      :city => strcity, 
      :gender => strgender,
      :name_option => strpub_name_option,
      :birthday_option => strpub_birthday_option,
      :blog => strblog, 
      :blog_option => strpub_blog,
      :email => strfavorite_email,
      :email_option => strpub_email_option,
      :qq => strqq,
      :qq_option => strred_qq,
      :msn => strmsn,
      :msn_option => strpub_msn_option,
      :mydesc => strmydesc,
      :Date_Year => strDate_Year,
      :Date_Month => strDate_Month,
      :Date_Day => strDate_Day
    });
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end

end
