
# Blog Sections

# Articles Section
activate :blog do |blog|
  blog.name = "articles"
  blog.prefix = "articles"
  blog.layout = "layouts/article"
  blog.taglink = "tags/{tag}.html"
  blog.tag_template = "articles/tag.html"
  blog.permalink = "{title}.html"
  blog.new_article_template = File.expand_path('./article_templates/article.erb', File.dirname(__FILE__))
  blog.paginate = true
  blog.per_page = 10

  blog.custom_collections = {
    category: {
      link: 'categories/{category}.html',
      template: 'articles/category.html'
    },
    series: {
      link: 'series/{series}.html',
      template: 'series.html'
    }
  }
end

# Directory Settings 
activate :directory_indexes
set :images_dir, "images"
set :fonts_dir, "fonts"
set :layout, "layouts/layout"
set :partials_dir, "partials"
set :relative_links, true

#Markdown Settings
# Loads different custom markdown extension based on ENV

if build?
  require 'lib/custom_markdown_extensions_production'
else
  require 'lib/custom_markdown_extensions_development'
end

helpers MarkdownHelper

# Markdown Options
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true,
              :smartypants => true,
              :tables => true,
              :highlight => true,
              :superscript => true,
              :renderer => MarkdownHelper::MyRenderer
              
activate :syntax


#Layouts Settings
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page '/404.html', directory_index: false
set :not_found_page, "404.html"

# Helpers Section
# Loads two sets of helpers based on the environment used

if build? 
  require 'lib/custom_helpers_production'
  require 'lib/page_meta_data'
  require 'lib/collection_utilities'
else
  # Helpers Reload issue potential fix (https://github.com/middleman/middleman/issues/1105)
  # Dir['lib/*'].each(&method(:load))
  require 'lib/custom_helpers_development'
  require 'lib/page_meta_data'
  require 'lib/collection_utilities'
end

# The names of the helpers that are loaded are the same, regardless of ENV
 
helpers CustomHelpers
helpers Metadata
helpers CollectionUtilities


# External asset pipeline configuration

activate :external_pipeline,
         name: :webpack,
         command: build? ? "NODE_ENV=production ./node_modules/webpack/bin/webpack.js --bail -p"
         : "NODE_ENV=development ./node_modules/webpack/bin/webpack.js --watch -d --color",
         source: ".tmp/dist",
         latency: 1

# Environment Specific Options
configure :development do
  activate :livereload
end

configure :build do
  activate :relative_assets
end
