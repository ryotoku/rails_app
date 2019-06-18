require 'rubygems'
require 'google/api_client'
require 'trollop'

class StaticPagesController < ApplicationController

  DEVELOPER_KEY = Settings.api_key
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def home
      @video = Video.new
      get_data
#      @video = Video.page(params[:page])
      @videos = Video.all
end

  def recommend
  end

  def popular
  end

  def get_service
    client = Google::APIClient.new(
      :key => DEVELOPER_KEY,
      :authorization => nil,
      :application_name => $PROGRAM_NAME,
      :application_version => '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    return client, youtube
  end

  def get_data
    require 'video.rb'
      opts = Trollop::options do
      opt :p, 'Search term', :type => String, :default => "ビリヤード"
      opt :max_results, 'Max results', :type => :int, :default => 5
      opt :order, 'order', :type => String, :default => 'date'
      opt :regionCode, 'region', :type => String, :default => 'JP'
    end

    client, youtube = get_service

    begin

      search_response = client.execute!(
        :api_method => youtube.search.list,
        :parameters => {
          :part => 'snippet',
          :p => opts[:p],
          :maxResults => opts[:max_results],
          :order => opts[:order],
          :regionCode => opts[:regionCode]
        }
      )
      videos = search_response.data.items#Jsonの中身が多かったので必要な情報のみ受けれるようにしています。

      videos.length.times { |result|
        Video.create(title: videos[result]["snippet"]["title"],
                      url: videos[result]["snippet"]["thumbnails"]["default"]["url"])
        @video.save
      }
    end
  end

end

