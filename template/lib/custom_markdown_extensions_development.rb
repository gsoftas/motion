module MarkdownHelper
  
  require 'middleman-core/renderers/redcarpet'
  require_relative 'custom_helpers_development'

  class MyRenderer < Middleman::Renderers::MiddlemanRedcarpetHTML  
    include CustomHelpers

    def initialize(options={})
      super
    end
  
    def paragraph(text)
      process_custom_tags("<p>#{text.strip}</p>\n")
    end

    def image(link, title, alt_text)
      process_custom_image(link, title, alt_text)
    end
  
  private 

    def process_custom_image(link, title, alt_text)

      # Responsive Image format:
      # ![ri Image Alt](Image/path "Image Title")
      
      if alt_text.match(/(ri )/)
        responsive_image(link, title)  
      else
        %(<img src="/images/#{link}" title="#{title}" alt="#{alt_text}">)
      end
    end
  
    def process_custom_tags(text)
      # Matches different types of 'custom' tags

      # Youtube videos
      if t = text.match(/(\[youtube-video )(\S* )(.+)(\])/)
        youtube_video(t[2], t[3])

      elsif t = text.match(/(\[youtube-video )(.+)(\])/)
        youtube_video(t[2])

      # Soundcloud tracks
      elsif t = text.match(/(\[)(soundcloud)( )(.+)(\])/)
        soundcloud_resource(t[4])

      # Spotify albums
      elsif t = text.match(/(\[)(spotify)( )(album)( )(.+)(\])/)
        spotify_resource("album", t[6])

      # Spotify playlist, resource should be in the form of: username/playlist/playlist_id    
      elsif t = text.match(/(\[)(spotify)( )(playlist)( )(.+)(\])/)
        spotify_resource("playlist", t[6])

      # Spotify tracks  
      elsif t = text.match(/(\[)(spotify)( )(track)( )(.+)(\])/)
        spotify_resource("track", t[6])

      # if no match is found, it returns the text as is
      else 
        return text
      end

    end

    # Retuns the HTML snippet for Youtube videos
    def youtube_video(resource_id, caption="")
      if caption == ""
        return <<-EOL
        <p>
        <div class="youtube-container column is-mobile center">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/#{resource_id}"  \ 
        frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
        </iframe>
        </div>
        </p>
        EOL
      else
        return <<-EOL
        <p>
        <div class="youtube-container column is-mobile center">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/#{resource_id}"  \ 
        frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
        </iframe>
        </div>
        <em>#{caption}</em>
        </p>
        EOL
      end
      
    end

    # Retuns the HTML snippet for Soundcloud resources
    def soundcloud_resource(resource_id)
      return <<-EOL
        <div class="soundcloud-container column is-mobile center">
        <iframe width="100%" height="300" scrolling="no" 
         frameborder="no" allow="autoplay" 
         src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/#{resource_id}&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true&visual=true"> 
         </iframe>
        </div>
        EOL
    end

    # Retuns the HTML snippet for Spotify resources, based on resource type
    def spotify_resource(resource_type, resource_id)
      if resource_type == "album"
        return <<-EOL
          <div class="spotify-container column is-mobile center">
          <iframe src="https://open.spotify.com/embed/album/#{resource_id}" width="100%" height="100%"  \ 
          frameborder="0" allowtransparency="true"></iframe>
          </div>
          EOL
      elsif resource_type == "track"
        return <<-EOL
          <div class="spotify-container column is-mobile center">
          <iframe src="https://open.spotify.com/embed/track/#{resource_id}" width="100%" height="100%" \
           frameborder="0" allowtransparency="true"></iframe>
          </div>
          EOL
      elsif resource_type == "playlist"
        return <<-EOL
          <div class="spotify-container column is-mobile center">
          <iframe src="https://open.spotify.com/embed/user/#{resource_id}" width="100%" height="100%" \
           frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>
          </div>
          EOL
      end
    end

    # Returns and HTML for a responsive image
    def responsive_image(image, caption="")
      name = image.match(/(.+)\.(jpg|jpeg|png|gif)/)[1]
      extension = image.match(/(.+)\.(jpg|jpeg|png|gif)/)[2]

      if caption == ""
        return <<-EOL
        <p class="center">
        <picture>
        <img src="/images/#{name}.#{extension}" alt="Responsive Image" style="width:auto; background: lightgrey; min-height: 10rem;" srcset="/images/#{name}.#{extension}">
        </picture>
        </p>
        EOL
      else
        return <<-EOL
        <p class="center">
        <picture>
        <img src="/images/#{name}.#{extension}" alt="Responsive Image" style="width:auto; background: lightgrey; min-height: 10rem;" srcset="/images/#{name}.#{extension}">
        <em>#{caption}</em>
        </picture>
        </p>
        EOL
      end
    end
  end
end

