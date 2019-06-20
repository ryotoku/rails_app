require 'rubygems'
require 'google/api_client'
require 'optimist'

module StaticPagesHelper

  DEVELOPER_KEY = Settings.api_key
  YOUTUBE_API_SERVICE_NAME = Settings.api_name
  YOUTUBE_API_VERSION = Settings.api_ver

  def get_service
    client = Google::APIClient.new(
      key: DEVELOPER_KEY,
      authorization: nil,
      application_name: $PROGRAM_NAME,
      application_version: Settings.app_ver
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    return client, youtube
  end

  def get_data
    opts = Optimist::options do
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
          :q => opts[:p],
          :maxResults => opts[:max_results],
          :order => opts[:order],
          :regionCode => opts[:regionCode]
        }
      )
      videos = search_response.data.items#Jsonの中身が多かったので必要な情報のみ受けれるようにしています。

      for video_index in 0..videos.length - 1 do
          Video.create!(id: video_index,
                        title: videos[video_index]["snippet"]["title"],
                        url: videos[video_index]["snippet"]["thumbnails"]["default"]["url"])
      end
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end

end
