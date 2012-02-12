class WeiboUsersController < ApplicationController
  before_filter :account_info
  
  def user_select
    @strsession = ""
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def user_display
    strselect = params[:strselect]
    strsintro = params[:strsintro]
    strsdomain = params[:strsdomain] 
    strgender = params[:strgender]
    strcity = params[:strcity]
    strprovince = params[:strprovince]
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(@txtkey1, @txtkey2)
    @userselect = Weibo::Base.new(oauth).user_search(strselect,{:sintro => strsintro, :sdomain => strsdomain, :gender => strgender, :province => strprovince, :city => strcity})
    @friendship = selfriendship(@userselect)
    #@friendship = ""
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def selected_display
    strtype = params[:type]
    strcode = params[:code]
    
    if(strtype == "province") then
      @struserselect = ProvinceCity.find_by_sql("select * from province_cities where ParentCode in ('CN','REST')").to_json
    end
    
    if(strtype == "city") then
      @struserselect = ProvinceCity.find_all_by_ParentCode(strcode).to_json
    end
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end

  
  # 显示单个用户信息
  def show
    struserid = params[:user_id].to_i
    if(struserid == nil || struserid == "") then
      @weibo_user=""
    else
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      #oauth.authorize_from_access("11d3f4ba88c23cb0ff2e15dd0ab1d1fc","763739c2df44939b7caa41f0b9a00506")
      oauth.authorize_from_access(@txtkey1,@txtkey2)
      @weibo_user=Weibo::Base.new(oauth).user(struserid)
      @following = following(@account.id,@weibo_user.id)
    end

    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.js
      format.json  { render :json => @weibo_user }
    end
  end
  

  private
  #检查source_id 是否关注 target_id 返回 true or false
  def following(source_id,target_id)  
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@txtkey1,@txtkey2)
      usergz = Weibo::Base.new(oauth).friendship_show({:source_id  => source_id, :target_id => target_id })
      @following = usergz.source.following
  end
  
  #获取当前登录帐号的 微博user 信息
  def account_info
    if user_signed_in?
      @userkey = Userkey.find(current_user.id)
    else
      @userkey = Userkey.find(1)
    end
      @txtkey1 = @userkey.key1
      @txtkey2 = @userkey.key2
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@txtkey1,@txtkey2)
    #获取当前登录帐号的 微博user 信息
    @account=Weibo::Base.new(oauth).verify_credentials()
  end
  
  def selfriendship(txtuserselect)
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(@txtkey1, @txtkey2)
    friendship = Array.new
    txtuserselect.each do |userselect|
      usergz = Weibo::Base.new(oauth).friendship_show({:source_id  => @account.id, :target_id => userselect.id })
      friendship.push(usergz.source.following)
    end
    return friendship
  end    
end
