module NetworksHelper


	def sort_posts(posts, filter, order)
		# if filter == "engagement rate"
		# 	filter = "engagement"
		# end
		@posts = posts.order("#{filter} #{order}")
		return @posts
	end


	def get_search_stats(posts, network, metric)
		count = posts.count
		if metric == "likes"
			 return (posts.sum(:likes).to_f/count.to_f)
		elsif metric == "comments"
			return (posts.sum(:comments).to_f/count.to_f)
		elsif metric == "shares"
			return (posts.sum(:shares).to_f/count.to_f)
		elsif metric == "engagement" 
			return (posts.sum(:engagement).to_f/count.to_f)
		else
			return 0
		end
	end


end
