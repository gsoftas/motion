module CustomHelpers
  require_relative 'page_meta_data'

  # Returns a formatted date or nothing if date is nil or empty
  def formatted_date(raw_date)
    (raw_date != nil || raw_date != '') ? Date.parse(raw_date.to_s).strftime("%B %d, %Y") : ''
  end

  # Returns the relative image path for the supplied image or 'noImage' if image is not valid
  def image_source(image_filename)
    image_filename ? "/images/" + image_filename : "/images/NoImage.svg"
  end

  # Returns the absolute image path for the supplied image or 'noImage' if image is not available
  def absolute_image_source(image)
    image ? data.site.url + "/images/" + image : "/images/NoImage.svg"
  end

  # Returns a string of the tags used in an article or other resource. Used in the entries.json file
  def tags_as_a_string(array)
    array.size > 0 ? array.join(", ") : ""
  end

  # Returns a properly cased title. Similar to the Rails method titleize(), hence the name
  def titleize(input)

    titleized_input = input.split(' ').map do |input| 
      # Check input to see if it's fully lowercase 
      if input == input.downcase 
        input.gsub(/\w+/) do |w|
          w.capitalize
        end
      else  
        input.gsub(/\W+/) do |w|
          w.capitalize
        end
      end
    end

    titleized_input.join(' ')
  end

  # Returns a string containing an estimation of the average time to read an article. 
  def time_to_read(article)
    words_per_minute = 200

    time = strip_tags(article.body).split.count / words_per_minute

    time <= 1 ? "About 1 minute read" : "About #{time} minutes read"
  end

  # Returns the CSS class 'menu-active' is the current page matches the page url
  def is_active_page?(page)
    current_page.url == page ? 'menu-active' :  ''
  end

  # Returns a string containing the page title concatenated with the site title or just the site title, 
  # if title is not available
  def page_title(current_page)
    
    current_page.data.title != nil ? "#{current_page.data.title} • #{data.site.title}" : data.site.title
  end

  # Returns the current page full URL
  def page_url(current_page)
    "#{data.site.url}#{current_page.url}"
  end

  # Retuns an HTML snippet containing the markup for a responsive image
  def responsive_image(image) 
    return "/images/NoImage.svg" unless image != nil

    # Get the image name without the extension. The filename should NOT contain any '.' before the extension
    name = image.match(/(.+)\.(jpg|jpeg|png|gif)/)[1]
    extension = image.match(/(.+)\.(jpg|jpeg|png|gif)/)[2]

    return <<-EOL
    <img src="/images/#{name}.#{extension}" alt="/images/#{name}.#{extension}"
    srcset="/images/#{name}-400px.#{extension} 400w, /images/#{name}-800px.#{extension} 800w, /images/#{name}-1200px.#{extension} 1200w">
    EOL
  end

  # Retuns an HTML snippet containing the markup for a responsive image thumbnail
  def responsive_thumbnail_path(image)
    return "/images/NoImage.svg" unless image != nil

    name = image.match(/(.+)\.(jpg|jpeg|png|gif)/)[1]
    extension = image.match(/(.+)\.(jpg|jpeg|png|gif)/)[2]

    File.file?("/images/#{name}-thumbnail.#{extension}") ? "/images/#{name}-thumbnail.#{extension}" : "/images/#{image}"
  end

  # Returns a string containing the last modified time for the current page
  def modified_file_date(current_page)
    File.mtime(current_page.source_file).iso8601
  end

  # Returns the CSS markup for the cover opacity. Used to darken or lighten article cover opacities to better suit the image
  def cover_opacity
    current_page.data.cover_opacity ? 
    "linear-gradient(rgba(0, 0, 0, #{current_page.data.cover_opacity}),rgba(0, 0, 0, #{current_page.data.cover_opacity}))" : 
    "linear-gradient(rgba(0, 0, 0, 0.3),rgba(0, 0, 0, 0.3))"
  end

  # Returns a string containing the last time the article was modified or the date it was published
  def published_or_updated_last(article)
    published = article.data.date
    last_updated = article.data.last_update_date

    return "Published on #{formatted_date(published)}" unless last_updated != nil

    (last_updated != nil || last_updated > published) ? "Last updated on #{formatted_date(last_updated)}" : "Published on #{formatted_date(published)}"
  end

  # Returns a string containing a resource summary if the article doesn't have a summary defined in its frontmatter
  def resource_summary(resource)
    return strip_tags(resource.summary(200)) unless resource.data.summary != nil

    return resource.data.summary
    
  end
end