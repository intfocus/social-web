#encoding : utf-8
%w(rubygems bundler).each { |dependency| require dependency }
Bundler.setup
%w(sinatra oauth sass json weibo mysql delayed_job).each { |dependency| require dependency }
enable :sessions
Weibo::Config.api_key = "2942145647"
Weibo::Config.api_secret = "5cc0026c470a25a6070237e07ade5f27"

class MessagesController < ApplicationController
  def upload_message
    if (session["imagefile"] != nil) then
      @imgf = session["imagefile"]
    else
      @imgf = ""
    end
    
    @strmessage = UploadMessage.find(:all)
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
    @strmessage = params[:strmes]
    @strimage = params[:strimg]
    @struploadtime = Time.now+5*60
    @strusername = "eric_yue"
    @strid = params[:strid]
    if !@strmessage.blank? && !@strimage.blank? then
      UploadMessage.create({:message => @strmessage, :image => @strimage, :isselected => 1, :uploadtime => @struploadtime, :username => @strusername })
      #redirect_to "/messages/test_message"
      #Delayed::Job.enqueue(Jobsmessage.new(@strmessage,@strimage),3, 1.minute.from_now)
    else 
      if !@strmessage.blank?
        UploadMessage.create({:message => @strmessage, :isselected => 1, :uploadtime => @struploadtime, :username => @strusername })
      end
    end
    
    if !@strid.blank? then
      str = @strid.split(",")
      str.each do |strid|
        messupdate = UploadMessage.find(strid)
        messupdate.update_attributes({:message => "ammount", :isselected => 0})
      end
    end
    
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def test_message
    @strid = params[:strid]
    @session1 = @strid
    @strid.each do |strid|
      
    end
    #oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    #oauth.authorize_from_access("11d3f4ba88c23cb0ff2e15dd0ab1d1fc","763739c2df44939b7caa41f0b9a00506")
    #Weibo::Base.new(oauth).upload(CGI::escape("测试222"),File.new("d:\\1.jpeg","rb"))
    #Delayed::Job.enqueue(Jobsmessage.new(), 3, 1.minute.from_now)
    respond_to do |format|
      format.html { render :layout => false } #:layout => false 设置不使用页面框架
      #format.json  { render :json => @home }
    end
  end
  
  def jobs_message
    
  end

end

class Jobsmessage
  
  def initialize(strm,strimage)
    @@mstr = strm
    @@imagestr = strimage
    webc.deliver 
  end
  def webc
    oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    oauth.authorize_from_access("11d3f4ba88c23cb0ff2e15dd0ab1d1fc","763739c2df44939b7caa41f0b9a00506")
    Weibo::Base.new(oauth).upload(CGI::escape(@@mstr),File.new("D:\\test\\social-web\\public\\" + @@imagestr ,"rb"))
  end
  def perform
    webc.deliver
  end
end