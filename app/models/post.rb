class Post < ActiveRecord::Base

	belongs_to :network



	def self.create_from_facebook(post, impressions, network)
		@p = Post.create(fb_id: post['id'].to_s, copy: post['message'], kind: post['type'], date: post['created_time'], network_id: network)
                unless post['message']
								@p.copy = "Shared post"
							end
                if post['likes']
                    @p.likes = post['likes']['data'].count 
                else
                    @p.likes = 0
                end
                if post['comments']
                    @p.comments = post['comments']['data'].count
                else
                    @p.comments = 0
                end
                if post['shares'] && post['shares']['count']
                    @p.shares = post['shares']['count']
                else
                    @p.shares = 0
                end
                if post['type'] == 'photo'
                	@p.link = post['link']
                else
					@p.link = "http://www.facebook.com/#{post['id']}"
				end
                @action_count = (@p.likes.to_f + @p.comments.to_f + @p.shares.to_f)
				@p.engagement = (@action_count.to_f/impressions.to_f)
		@p.save
	end


	def self.get_stats(network)
		@types = ["all", "photo", "status", "link", "video", "swf"]
		@all_posts = Post.where(network_id: network).load
		
		@types.each do |t|
			unless t == "all"
				@posts = @all_posts.where(kind: t)
			else
				@posts = @all_posts
			end
			@count = @posts.count
			@tot_likes = 0
			@tot_comments = 0
			@tot_shares = 0
			@tot_eng = 0.0
			@avg_likes = 0.0
			@avg_comments = 0.0
			@avg_shares = 0.0
			@avg_eng = 0.0
			@posts.each do |p|
				if p.likes
					@tot_likes += p.likes
				end
				if p.comments
					@tot_comments += p.comments
				end
				if p.shares
					@tot_shares += p.shares
				end
				if p.engagement
					@tot_eng += p.engagement
				end
			end
			@avg_likes = (@tot_likes.to_f/@count.to_f)
			@avg_comments = (@tot_comments.to_f/@count.to_f)
			@avg_shares = (@tot_shares.to_f/@count.to_f)
			@avg_eng = (@tot_eng.to_f/@count.to_f)
			puts "======= Results for #{t} ========"
			puts "Count: #{@count}"
			puts "======= Averages ========"
			puts "| Likes: #{@avg_likes.round(2)}"
			puts "| Comments: #{@avg_comments.round(2)}"
			puts "| Shares: #{@avg_shares.round(2)}"
			puts "| Engagement #{@avg_eng.round(30)}"
		end
	end

	def self.get_analytics(metric, type, network)
		count = Post.where(network_id: network).where(kind: "#{type}").count
		if metric == "likes"
			sum = Post.sum(:likes, :conditions => {network_id: network, kind: "#{type}"})
		elsif metric == "comments"
			sum = Post.sum(:comments, :conditions => {network_id: network, kind: "#{type}"})
		elsif metric == "status"
			sum = Post.sum(:shares, :conditions => {network_id: network, kind: "#{type}"})
		elsif metric == "engagement"
			sum = Post.sum(:engagement, :conditions => {network_id: network, kind: "#{type}"})
		else
			sum = 1
		end
		@average = sum.to_f/count.to_f
		return @average
	end



	
end
