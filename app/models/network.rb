class Network < ActiveRecord::Base
 
has_many :posts
 
has_attached_file :logo, :styles => { :large => "640x360>", :medium => "320x180", :small => "160x90", :thumb => "80x45>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
 
 
  def search_posts(keyword)
    return self.posts.where("copy LIKE ?", "%#{keyword}%")
  end

	def get_graph_posts(num)
		@graph = Koala::Facebook::API.new(ENV["FACEBOOK_ACCESS_TOKEN"])
		@posts = @graph.get_connections(self.fb_id, "posts", :limit => num)
		return @posts
	end

	def calc_eng
		# Change the below to a variable that is input to get a more acccurate impression count for each post.
		impressions = (0.05 * self.fb_fans.to_f)

		self.posts.each do |p|
			action_count = (p.likes.to_f + p.comments.to_f + p.shares.to_f)
			p.engagement = (action_count.to_f/impressions.to_f)
			p.save
		end
		return false
	end

	def create_post

	end

	def update_posts
		@latest_post = self.posts.first.date
		impressions = (0.05 * self.fb_fans.to_f)
		@num = 100
		@posts = self.get_graph_posts(@num)
		@posts.each do |p|
			@pdate = p['created_time'].to_datetime
			if @pdate > @latest_post
				Post.create_from_facebook(p, impressions, self.id)
			else
				return false
			end
		end	
	end
 
def get_posts(numPages)
    @pages = numPages.to_i
    impressions = (0.05 * self.fb_fans.to_f)
    @posts = self.get_graph_posts(100)
    @posts.each do |p|
        if p["from"]["name"] == "#{self.name}"
        	Post.create_from_facebook(p, impressions, self.id)
        end
        # @postCount += 1
    end
    @page = 1
    while @page < (@pages + 1)
	        @posts = @posts.next_page
	        @posts.each do |p|
	            if p["from"]["name"] == "#{self.name}"
	            	Post.create_from_facebook(p, impressions, self.id)
	            end
	        end
            @page += 1
 	end
end
 
 
    def update_likes
        @graph = Koala::Facebook::API.new(ENV["FACEBOOK_ACCESS_TOKEN"])
        @likes = @graph.get_object(self.fb_id)['likes']
        self.fb_fans = @likes
        self.save
    end
 
end