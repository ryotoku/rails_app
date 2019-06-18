require 'rubygems'
require 'google/api_client'
require 'trollop'

module StaticPagesHelper

  DEVELOPER_KEY = Settings.api_key
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

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
      opt :q, 'Search term', :type => String, :default => "ビリヤード"
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
          :q => opts[:q],
          :maxResults => opts[:max_results],
          :order => opts[:order],
          :regionCode => opts[:regionCode]
        }
      )
      videos = search_response.data.items#Jsonの中身が多かったので必要な情報のみ受けれるようにしています。

      for video_index in 0..videos.length - 1 do
#        if Video.blank?
          Video.create( id: video_index,
                        title: videos[video_index]["snippet"]["title"],
                        url: videos[video_index]["snippet"]["thumbnails"]["default"]["url"])
#        else
#          Video.create( title: videos[video_index]["snippet"]["title"],
#                        url: videos[video_index]["snippet"]["thumbnails"]["default"]["url"])
#        end
        @video.save
      end
    end
  end

end
