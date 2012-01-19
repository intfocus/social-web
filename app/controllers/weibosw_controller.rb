#encoding : utf-8
class WeiboswController < ApplicationController
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
    flash[:notice]="文件："+ newfilename+"上传成功。"+
        "上传时间是："+(Time.now).to_s+
        "上传的地址是："+ "#{Rails.root}/public/"
    render :action=>"/upload_message"
  end
  
  def uploadImg
    
  end

end