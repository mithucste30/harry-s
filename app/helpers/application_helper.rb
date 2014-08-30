module ApplicationHelper

  def asset_url asset
    "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
  end

  def short_url(url)
    bitly = Bitly.new('o_m7ita424g','R_4c3439e08b554c08ba9c9c58d5caf808')
    shorten_url = bitly.shorten(url, :history => 1).short_url
    return shorten_url
  end

  def tweet_url(opts)        
    url = root_url(:ref => opts[:ref])
    url = short_url(url)    
    return url
  end
end
