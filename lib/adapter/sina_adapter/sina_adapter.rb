require 'forwardable'
require 'rubygems'

gem 'oauth', '~> 0.4.1'
require 'oauth'

gem 'hashie'
require 'hashie'

gem 'httparty', '>= 0.5.2'
require 'httparty'

module Sina_adapter
  class WeiboError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data

      super
    end
  end
  class RepeatedWeiboText < WeiboError; end
  class RateLimitExceeded < WeiboError; end
  class Unauthorized      < WeiboError; end
  class General           < WeiboError; end

  class Unavailable       < StandardError; end
  class InformWeibo       < StandardError; end
  class NotFound          < StandardError; end
end

module Hashie
  class Mash

    # Converts all of the keys to strings, optionally formatting key name
    def rubyify_keys!
      keys.each{|k|
        v = delete(k)
        new_key = k.to_s.underscore
        self[new_key] = v
        v.rubyify_keys! if v.is_a?(Hash)
        v.each{|p| p.rubyify_keys! if p.is_a?(Hash)} if v.is_a?(Array)
      }
      self
    end

  end
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'sina_adapter', 'oauth')
require File.join(directory, 'sina_adapter', 'oauth_hack')
require File.join(directory, 'sina_adapter', 'httpauth')
require File.join(directory, 'sina_adapter', 'request')
require File.join(directory, 'sina_adapter', 'config')
require File.join(directory, 'sina_adapter', 'base')

# code is an adaptation of the twitter gem by John Nunemaker
# http://github.com/jnunemaker/twitter
# Copyright (c) 2009 John Nunemaker
# 
# made to work with china's leading twitter service, 新浪微博
