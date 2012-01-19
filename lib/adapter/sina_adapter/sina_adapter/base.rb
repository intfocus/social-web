module Sina_adapter
  class Base
    extend Forwardable

    def_delegators :client, :get, :post, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    def provinces(query={})
      perform_get('/provinces.json', :query => query)
    end

    def status_search(q, query={})
      q = URI.escape(q)
      if q != ""
        query = {:q => q}.merge(query)
      end
      perform_get('/statuses/search.json', :query => query)
    end

    def user_search(q, query={})
      q = URI.escape(q)
      if q != ""
        query = {:q => q}.merge(query)
      end
      perform_get('/users/search.json', :query => query)
    end

    # statuses/public_timeline 最新公共微博
    def firehose
      perform_get('/statuses/public_timeline.json')
    end


    # Options: since_id, max_id, count, page
    def home_timeline(query={})
      perform_get('/statuses/home_timeline.json', :query => query)
    end


    # statuses/friends_timeline 最新关注人微博 (别名: statuses/home_timeline)
    # Options: since_id, max_id, count, page, since
    def friends_timeline(query={})
      perform_get('/statuses/friends_timeline.json', :query => query)
    end

    # statuses/user_timeline 用户发表微博列表
    # Options: id, user_id, screen_name, since_id, max_id, page, since, count
    def user_timeline(query={})
      perform_get('/statuses/user_timeline.json', :query => query)
    end

    # statuses/show 获取单条
    def status(id)
      perform_get("/statuses/show/#{id}.json")
    end
    
    def counts(query={})
      perform_get("/statuses/counts.json", :query => query)
    end

    # Options: count
    def retweets(id, query={ })
      perform_get("/statuses/retweets/#{id}.json", :query => query)
    end

    # * statuses/update 发表微博
    # Options: in_reply_to_status_id
    def update(status, query={})
      perform_post("/statuses/update.json", :body => {:status => status}.merge(query))
    end

    # DEPRECATED: Use #mentions instead
    #
    # Options: since_id, max_id, since, page
    # statuses/mentions 最新 @用户的
    def replies(query={})
      warn("DEPRECATED: #replies is deprecated by Twitter; use #mentions instead")
      perform_get('/statuses/mentions.json', :query => query)
    end

    # statuses/mentions 最新 @用户的
    # Options: since_id, max_id, count, page
    def mentions(query={})
      perform_get('/statuses/mentions.json', :query => query)
    end


    def upload(status, file)
      PostBodyHack.apply_hack(:status => status) do
        perform_post("/statuses/upload.json", build_multipart_bodies(:pic => file, :status => status))
      end
    end

    def reply(comment, query={})
      perform_post("/statuses/reply.json", :body => {:comment => comment}.merge(query))
    end

    def comment(id, comment, query={})
      perform_post("/statuses/comment.json", :body => {:id => id, :comment => comment}.merge(query))
    end

    def unread
      perform_get('/statuses/unread.json')
    end

    def comments_timeline(query={})
      perform_get('/statuses/comments_timeline.json', :query => query)
    end

    def comments_by_me(query={})
      perform_get('/statuses/comments_by_me.json', :query => query)
    end

    def comments(query={})
      perform_get('/statuses/comments.json', :query => query)
    end

    def comment_destroy(id)
      perform_post("/statuses/comment_destroy/#{id}.json")
    end

    # statuses/destroy 删除
    def status_destroy(id)
      perform_post("/statuses/destroy/#{id}.json")
    end

    # statuses/repost 转发
    def retweet(id)
      perform_post("/statuses/repost/#{id}.json")
    end

    # statuses/repost 转发
    def repost(id, status={})
      perform_post("/statuses/repost.json", :body => {:id => id}.merge(status))
    end

    # statuses/friends 关注人列表
    # Options: id, user_id, screen_name, page
    def friends(query={})
      perform_get('/statuses/friends.json', :query => query)
    end

    # statuses/followers 粉丝列表
    # Options: id, user_id, screen_name, page
    def followers(query={})
      perform_get('/statuses/followers.json', :query => query)
    end

    def user(id, query={})
      perform_get("/users/show/#{id}.json", :query => query)
    end

    def user_show(query={})
      perform_get("/users/show.json", :query => query)
    end


    # direct_messages 我的私信列表
    # Options: since, since_id, page
    def direct_messages(query={})
      perform_get("/direct_messages.json", :query => query)
    end

    # direct_messages/sent 我发送的私信列表
    # Options: since, since_id, page
    def direct_messages_sent(query={})
      perform_get("/direct_messages/sent.json", :query => query)
    end


    # direct_messages/new 发送私信
    def direct_message_create(user, screen_name, text)
      perform_post("/direct_messages/new.json", :body => {:id => user, :screen_name => screen_name, :text => text})
    end

    # direct_messages/destroy 删除一条私信
    def direct_message_destroy(id)
      perform_post("/direct_messages/destroy/#{id}.json")
    end

    # friendships/create 关注某用户
    def friendship_create(id, follow=false)
      body = {}
      body.merge!(:follow => follow) if follow
      perform_post("/friendships/create/#{id}.json", :body => body)
    end

    # friendships/destroy 取消关注
    def friendship_destroy(id)
      perform_delete("/friendships/destroy/#{id}.json")
    end

    # friendships/exists 是否关注某用户(推荐使用friendships/show)
    def friendship_exists?(a, b)
      perform_get("/friendships/exists.json", :query => {:user_a => a, :user_b => b})
    end

    # friendships/show 是否关注某用户
    def friendship_show(query)
      perform_get("/friendships/show.json", :query => query)
    end

    # friends/ids  关注列表
    # Options: id, user_id, screen_name
    def friend_ids(query={})
      perform_get("/friends/ids.json", :query => query, :mash => false)
    end

    # followers/ids 粉丝列表
    # Options: id, user_id, screen_name
    def follower_ids(query={})
      perform_get("/followers/ids.json", :query => query, :mash => false)
    end

    # account/verify_credentials 验证身份是否合法
    def verify_credentials
      perform_get("/account/verify_credentials.json")
    end

    # unimplemented
    # account/end_session 退出
    def end_session(body={})
      perform_post('/account/end_session.json')
    end

    # account/update_profile_image 更改头像
    # file should respond to #read and #path
    def update_profile_image(file)
      PostBodyHack.apply_hack do
        perform_post('/account/update_profile_image.json', build_multipart_bodies(:image => file))
      end
    end

    # account/rate_limit_status 查看当前频率限制
    def rate_limit_status
      perform_get('/account/rate_limit_status.json')
    end

    # account/update_profile 更改资料
    # One or more of the following must be present:
    #   name, email, url, location, description
    def update_profile(body={})
      perform_post('/account/update_profile.json', :body => body)
    end

    # favorites 收藏列表
    # Options: id, page
    def favorites(query={})
      perform_get('/favorites.json', :query => query)
    end

    # favorites/create 添加收藏
    def favorite_create(id)
      perform_post("/favorites/create/#{id}.json")
    end

    # favorites/destroy 删除收藏
    def favorite_destroy(id)
      perform_post("/favorites/destroy/#{id}.json")
    end

    def help
      perform_get('/help/test.json')
    end

  protected
    def self.mime_type(file)
      case
        when file =~ /\.jpg/ then 'image/jpg'
        when file =~ /\.gif$/ then 'image/gif'
        when file =~ /\.png$/ then 'image/png'
        else 'application/octet-stream'
      end
    end
    def mime_type(f) self.class.mime_type(f) end

    CRLF = "\r\n"
    def self.build_multipart_bodies(parts)
      boundary = Time.now.to_i.to_s(16)
      body = ""
      parts.each do |key, value|
        esc_key = CGI.escape(key.to_s)
        body << "--#{boundary}#{CRLF}"
        if value.respond_to?(:read)
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"; filename=\"#{File.basename(value.path)}\"#{CRLF}"
          body << "Content-Type: #{mime_type(value.path)}#{CRLF*2}"
          body << value.read
        else
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"#{CRLF*2}#{value}"
        end
        body << CRLF
      end
      body << "--#{boundary}--#{CRLF*2}"
      {
        :body => body,
        :headers => {"Content-Type" => "multipart/form-data; boundary=#{boundary}"}
      }
    end
    def build_multipart_bodies(parts) self.class.build_multipart_bodies(parts) end

    private
      def perform_get(path, options={})
        options[:query] = {} unless options[:query]
        options[:query][:source] = Weibo::Config.api_key
        Weibo::Request.get(self, path, options)
      end

      def perform_post(path, options={})
        options[:query] = {} unless options[:query]
        options[:query][:source] = Weibo::Config.api_key
        Weibo::Request.post(self, path, options)
      end

      def perform_put(path, options={})
        options[:query] = {} unless options[:query]
        options[:query][:source] = Weibo::Config.api_key

        Weibo::Request.put(self, path, options)
      end

      def perform_delete(path, options={})
        options[:query] = {} unless options[:query]
        options[:query][:source] = Weibo::Config.api_key
        Weibo::Request.delete(self, path, options)
      end
  end
end
