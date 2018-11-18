module CollectionUtilities

  # Returns an array of articles for a specific series
  
  def blog_series(blog_name)
    b = blog(blog_name)

    ht = Hash.new { |h,k| h[k] = [] }

    b.articles.each do |a|
      ht[a.data.series].append a unless a.data.series == nil
    end

    ht
  end

  # Returns an array of the last (newest) 5 featured articles. 
  # Checks the frontmatter variable 'featured' to determine if article 
  # should be included or not
  
  def featured_posts

    featured_posts = []

    data.site.site_sections.each do |section|
     featured_posts << blog(section).articles.select {|article| article.data.featured == true }
    end

    featured_posts.flatten!.sort! {|a,b| b.date <=> a.date }.take 5
   
  end

  # Returns an array of sorted items. The collection can be sorted
  # in asceding or descending alphabetical or date order
  # In case some other option is passed, the collection gets returned unchanged
  
  def sort_collection(collection, type="alphabetical", order="asc")
    case type
      when "alphabetical"
        if order == "asc" 
          return collection.sort {|a,b| a.downcase <=> b.downcase } 
        end

        if order == "desc"
          return collection.sort {|a,b| b.downcase <=> a.downcase }
        end
      when "date"
        if order == "asc" 
          return collection.sort {|a,b| a <=> b }
        end

        if order == "desc"
          return collection.sort {|a,b| b <=> a  }
        end
      else
        return collection
    end
  end
end