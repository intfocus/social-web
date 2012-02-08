#encoding : utf-8

class MessagesController < ApplicationController
  def upload_message
    if (session["imagefile"] != nil) then
      @imgf = session["imagefile"]
    else
      @imgf = ""
    end
    
    @strmessage = UploadMessage.find(:all, :conditions => "isselected!=0", :order => "id desc")
  end
  
  def upload_edit
    if (session["imagefile"] != nil) then
      @imgf = session["imagefile"]
    else
      @imgf = ""
    end
    
    stronemessage = UploadMessage.find_by_id(params[:id])
    @txtid= stronemessage.id
    @txtmessage = stronemessage.message.strip
    @imgf = stronemessage.image
    @txtisselected = stronemessage.isselected
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      format.json  { render :json => @strselectmessage }
    end
  end
  
  def upload
    image=params[:img]
    content_size=image.size
    file_data=image.read
    filetype=image.content_type
    @filename=image.original_filename
    fileext=File.basename(@filename).split(".")[1]
    @time=Time.now.strftime("%Y-%m-%d-%H-%M-%S")
    timeext=File.basename(@time)
    newfilename=timeext+"."+fileext
    File.open("#{Rails.root}/public/"+ newfilename,"wb"){
      |f| f.write(file_data)
    }
    #flash[:notice]="文件："+ newfilename+"上传成功。"+
    #    "上传时间是："+(Time.now).to_s+
    #    "上传的地址是："+ "#{Rails.root}/public/"
    session["imagefile"] = newfilename
    redirect_to "/messages/upload_message"
  end
  
  def img_message
    
  end
  
  def save_update
    @strtype = params[:strtype]
    if @strtype == "userrule" then
      if user_signed_in?
        @userid = current_user.id
      else
        @userid = 1
      end
      @strrulename = params[:strrulename]
      @strkeyword = params[:strkeyword]
      @strusername = params[:strusername]
      @filterori = params[:filterori]
      @strruleid = params[:strruleid]
      if @strruleid == nil && @strruleid == "" then
        RuleMessage.create({:user_id => @userid, :rulename => @strrulename, :keyword => @strkeyword, :username => @strusername, :filterori => @filterori});
      else
        rulemessage = RuleMessage.find(@strruleid)
        rulemessage.update_attributes({:rulename => @strrulename, :keyword => @strkeyword, :username => @strusername, :filterori => @filterori});
      end
    end
    
    if @strtype == "savemessage" then
      @strmessage = params[:strmes]
      @strimage = params[:strimg]
      @sendstate = params[:send_state]
      @struploadtime = Time.now+params[:clock].to_i*60
      if user_signed_in?
        @strusername = current_user.email
      else
        @strusername = "eric_yue"
      end
      @strid = params[:strid]
      if !@strmessage.blank? && !@strimage.blank? then
        UploadMessage.create({:message => @strmessage, :image => @strimage, :isselected => @sendstate, :uploadtime => @struploadtime, :username => @strusername })
        #redirect_to "/messages/test_message"
        #Delayed::Job.enqueue(Jobsmessage.new(@strmessage,@strimage),3, 1.minute.from_now)
      else 
        if !@strmessage.blank?
          UploadMessage.create({:message => @strmessage, :isselected => @sendstate, :uploadtime => @struploadtime, :username => @strusername })
        end
      end
    
      if !@strid.blank? then
        str = @strid.split(",")
        str.each do |strid|
          messupdate = UploadMessage.find(strid)
          messupdate.update_attributes({:isselected => 0})
        end
      end
    end
    
    if @strtype == "monitor" then
      datamonitor = DisplayMessage.find_by_WID(params[:wbid])
      datamonitor.update_attributes({:monitor => params[:strnum]});
    end
    
    if @strtype == "deletemessage" then
      @strid = params[:strid]
      if !@strid.blank? then
        str = @strid.split(",")
        str.each do |strid|
          messupdate = UploadMessage.find(strid)
          messupdate.update_attributes({:isselected => 0})
        end
      end
    end
    
    if @strtype == "deletemessage" then
      @strid = params[:strid]
      if !@strid.blank? then
        messupdate = UploadMessage.find(strid)
        messupdate.update_attributes({:isselected => 0})
      end
    end
    
    if @strtype == "updatemessage" then
      @strid = params[:strid]
      if !@strid.blank? then
        @strmessage = params[:strmessage]
        @strimage = params[:strimg]
        if @strimage == "" then
          @strimage = nil
        end
        @sendstate = params[:send_state]
        @struploadtime = Time.now+params[:clock].to_i*60
        messupdate = UploadMessage.find(@strid)
        messupdate.update_attributes({:message => @strmessage, :image => @strimage, :uploadtime => @struploadtime, :isselected => @sendstate})
      end
    end
    
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  def test_message1
    @strselectmessage=""
    #@strselectmessage = RuleMessage.find_by_user_id(1).to_json
    #return @strselectmessage
  end
  
  def test_message
    #@strselectmessage = RuleMessage.find_by_user_id(1).to_json
    #@txturl = "<a href='http://www.baidu.com'>百度</a>"    
    #rule_select_message
    #@strid = params[:strid]
    #@userkey = Userkey.find(current_user.id)
    #$txtkey1 = "11d3f4ba88c23cb0ff2e15dd0ab1d1fc"
    #$txtkey2 = "763739c2df44939b7caa41f0b9a00506"
    #$txtkey1 = @userkey.key1
    #@session1 = @userkey.key1
    #@strid.each do |strid|
      
    #end
    #oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    #oauth.authorize_from_access("11d3f4ba88c23cb0ff2e15dd0ab1d1fc","763739c2df44939b7caa41f0b9a00506")
    #Weibo::Base.new(oauth).upload(CGI::escape("测试222"),File.new("d:\\1.jpeg","rb"))
    #Delayed::Job.enqueue(Jobsmessage.new(), 3, 1.minute.from_now)
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      format.json  { render :json => @strselectmessage }
    end
  end
  
  def jobs_message
    
  end
  
  def select_message
    
  end
  
  def userrule_message
    if user_signed_in?
      @rulemessage = RuleMessage.find_by_user_id(current_user.id)
    else
      @rulemessage = RuleMessage.find_by_user_id(1)
    end
  end
  
  def display_message
    message_info
    strq = params[:strq]
    strfilterori = params[:strfilterori].to_i    
    strfilterpic = params[:strfilterpic].to_i
    if(strq == nil || strq == "") then
      @strmessage=""
      if user_signed_in?
        #@strselectmessage = DisplayMessage.find_all_by_user_id(current_user.id)
        @strselectmessage = DisplayMessage.find(:all, :conditions => "user_id=" + current_user.id.to_s, :order => "id desc")
      else
        #@strselectmessage = DisplayMessage.find_all_by_user_id(1)
        @strselectmessage = DisplayMessage.find(:all, :conditions => "user_id=1", :order => "id desc")
      end
    else
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      #oauth.authorize_from_access("11d3f4ba88c23cb0ff2e15dd0ab1d1fc","763739c2df44939b7caa41f0b9a00506")
      oauth.authorize_from_access($txtkey1,$txtkey2)
      @strmessage=Weibo::Base.new(oauth).status_search(strq,{:filter_pic => strfilterpic, :filter_ori => strfilterori})
    end
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def message_info
    if user_signed_in?
      @userkey = Userkey.find(current_user.id)
      #$txtkey1 = "11d3f4ba88c23cb0ff2e15dd0ab1d1fc"
      #$txtkey2 = "763739c2df44939b7caa41f0b9a00506"
      $txtkey1 = @userkey.key1
      $txtkey2 = @userkey.key2
    end
  end
  
  def edit_message
    @typetxt = params[:type]
    if (@typetxt == "repost") then
      @txttype = "转发"
      @txtmessage = "添加的转发文本"
    else
      @txttype = "评论"
      @txtmessage = "添加的评论文本"
    end
    @txtwbid = params[:wbid]
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def repost_message
    if user_signed_in?
      @userkey = Userkey.find(current_user.id)
    else
      @userkey = Userkey.find(1)
    end
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access(@userkey.key1, @userkey.key2)
    #@abc = Weibo::Base.new(oauth).friends_timeline.to_json
    if (params[:type] == "repost") then
      @abc = Weibo::Base.new(oauth).repost(params[:wbid],{:status  => params[:repost]})
    elsif (params[:type] == "comment") then
      @abc = Weibo::Base.new(oauth).comment(params[:wbid],params[:repost])
    end
  end
  
  def rule_select_message
    @testmessage = RuleMessage.find(:all)
    @txtint = 0
    @testmessage.each do |strmessage|
      if user_signed_in?
        @userkey = Userkey.find(current_user.id)
      else
        @userkey = Userkey.find(strmessage.user_id)
      end
      oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
      oauth.authorize_from_access(@userkey.key1, @userkey.key2)
      @userselect=Weibo::Base.new(oauth).user_search(strmessage.rulename)
      @userselect.each do |struser|
        user_id = strmessage.user_id
        uid = struser.id
        screen_name = struser.screen_name
        name = struser.name
        province = struser.province
        city = struser.city
        location = struser.location
        url = struser.url
        profile_image_url = struser.profile_image_url
        domain = struser.domain
        gender = struser.gender
        created_user = struser.created_at
        geo_enabled = struser.geo_enabled
        followers_count = struser.followers_count
        friends_count = struser.friends_count
        statuses_count = struser.statuses_count
        favourites_count = struser.favourites_count
        @number = Userkey.count_by_sql("select count(*) from username_selects where uid='#{uid}'")
        if @number == 0
          UsernameSelect.create({:user_id => user_id, :UID => uid, :screen_name => screen_name, :name => name, :province => province, :city => city, :location => location, :url => url, :profile_image_url => profile_image_url, :domain => domain, :gender => gender, :created_user => created_user, :followers_count => followers_count, :friends_count => friends_count, :statuses_count => statuses_count, :favourites_count => favourites_count });
        end
      end
      @strkeyword = strmessage.keyword
      @filter_ori = strmessage.filterori
      if !(@strkeyword == "") then
        stra = @strkeyword.split(",")
        stra.each do |strkeyword|
          @messageselect=Weibo::Base.new(oauth).status_search(strkeyword,{:filter_ori => @filter_ori })
          @messageselect.each do |messageselect|
            user_id = strmessage.user_id
            created_w = messageselect.created_at
            wid = messageselect.id
            wtext = messageselect.text
            if messageselect.source == nil || messageselect.source == ""
              source = " "
            else
              source = messageselect.source
            end
            wuser_id = messageselect.user.id
            screen_name = messageselect.user.screen_name
            user_name = messageselect.user.name
            user_location = messageselect.user.location
            profile_image_url = messageselect.user.profile_image_url
            @number = DisplayMessage.count_by_sql("select count(*) from display_messages where wid='#{wid}'")
            if @number == 0
              DisplayMessage.create({
                :user_id => user_id,
                :created_w => created_w,
                :WID => wid,
                :wtext => wtext,
                :source => source,
                :wuser_id => wuser_id,
                :screen_name => screen_name,
                :user_name => user_name,
                :user_location => user_location,
                :profile_image_url => profile_image_url,
                :monitor => 0 
              });
            end
          end
        end
      end
    end
  end
  
  def user_display_message
    if user_signed_in?
      @user_select_message = UsernameSelect.find_all_by_user_id(current_user.id)
    else
      @user_select_message = UsernameSelect.find_all_by_user_id(1)
    end
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end

end

class Jobsmessage
  
  def initialize(strm,strimage)
    @@mstr = strm
    @@imagestr = strimage
    message_info
    if (strimage == nil && strimage == "") then
      updatemessage.deliver
    else
      uploadmessage.deliver 
    end
    
  end
  def uploadmessage
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access($txtkey1,$txtkey2)
    #Weibo::Base.new(oauth).upload(CGI::escape(@@mstr),File.new("D:\\test\\social-web\\public\\" + @@imagestr ,"rb"))
    Weibo::Base.new(oauth).upload(CGI::escape(@@mstr),File.new(File.join(Rails.root.to_s, 'public', @@imagestr) ,"rb"))
  end
  
  def updatemessage
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access($txtkey1,$txtkey2)
    Weibo::Base.new(oauth).update(@@mstr)
  end
  
  def perform
    webc.deliver
  end
  
  def message_info
    if user_signed_in?
      @userkey = Userkey.find(current_user.id)
      #$txtkey1 = "11d3f4ba88c23cb0ff2e15dd0ab1d1fc"
      #$txtkey2 = "763739c2df44939b7caa41f0b9a00506"
      $txtkey1 = @userkey.key1
      $txtkey2 = @userkey.key2
    end
  end
  
  def send_monitor
    
  end
end