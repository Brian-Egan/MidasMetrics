require 'koala'

def get_posts(pageName, numPosts)

	@net = Network.where(name: "#{pageName}").take
	@graph = Koala::Facebook::API.new(ENV["FACEBOOK_ACCESS_TOKEN"])
	@feed = @graph.get_connections(@new.fb_id, "feed")
	@feed = @feed.select { |b| (b["from"]["name"] == "#{pageName}")}
	@postCount = 0
	@postIDs = []
	@feed.each do |p|
		@postIDs << p["id"].split("_")[1]
		@postCount += 1
	end
	puts @postIDs

	

end