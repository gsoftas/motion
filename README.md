![Motion Logo](https://raw.githubusercontent.com/gsoftas/motion/master/template/source/images/motion-logo.png)

Motion is a template for the [Middleman](https://middlemanapp.com) static site generator. It uses [Bulma](https://bulma.io/) for CSS, [React](https://reactjs.org/) for its search functionality, [Webpack](https://webpack.js.org/) for asset bundling and [Gulp](https://gulpjs.com/) for post-build optimisations to Images and Stylesheets.

# Creating a new Middleman site with Motion

Create a new Middleman project and use Motion as the template, using the following command:
`middleman init YOUR_PROJECT_NAME -T https://github.com/gsoftas/motion.git`. You can find detailed instruction on how Middleman Templates work [here](https://middlemanapp.com/advanced/project-templates/).

Once the initial stage of the middleman initialization is complete, we need to install the development dependencies for our project. The project uses the [Yarn](https://yarnpkg.com/en/) package manager to manage its development dependencies and the [Gulp](https://gulpjs.com/) task runner to run the build optimisation tasks. If You can run the following commands manually to install each package or execute the `bootstrap` script inside of the bin folder to install Yarn and Gulp globally and then instruct yarn to fetch our front-end dependencies once its installed.
Change directory to the one you created using `cd YOUR_PROJECT_NAME` and execute the following commands (if you want to install Yarn and Gulp locally just ignore the `-g` switch):

```shell
# Install Ruby Gems
bundle install

# Install Yarn globally
npm install yarn -g

# Install Gulp CLI globally
npm install gulp-cli -g

# Install JS Dependancies
yarn install
```

Once the process is complete you can run `middleman serve` or `middleman s` to start the development server. By default your new project will be available at `http://localhost:4567`.

# Content Management

## Pages & Articles
The project is structured in pages and articles. Pages are typically either landing pages (the articles listing page) or static content pages (like the about page), that do no change much (if at all). Articles have a more temporal meaning and can be thought as blog entries (that happen) over time or projects or any other type of structured information you want to have.

### Creating a new Page
You can create a page by either creating a `pagename.html.erb` file that will contain `ERB` or a `pagename.html.markdown` file that will contain `Markdown`, depending on the type of content you want the page to have. If you create a `Markdown` page, you need to include the following [frontmatter](https://middlemanapp.com/basics/frontmatter/):
```
---
title: About
layout: general_page
---
```
that will tell Middleman your page's title and the

### Creating a new Article
In order to create a new article you can use the following command: `bundle exec middleman article --blog 'articles' 'NAME_OF_ARTICLE'`, or run the `na` (new article) script located in the `bin` folder with the following command: `./bin/na 'NAME_OF_ARTICLE'`. Note that you need to make the `na` script executable in order to use the latter command. You can find instruction on how to do so inside the `na` script.

Once you create your new article it will be displayed in the articles page automatically.

## Asset Handling

Assets in Motion are handled by Webpack and Gulp. The two main asset categories we'll focus on this document are images and stylesheets.

### Images
All images are stored in `source/images` folder. When adding a new image file to the project, copy the file to the `images` folder dirrectly or to a sub-folder of your choice within the `images` folder. Use the largest version of the image available to you as it will be appropriately optimised when the website is built. In order to preserve space on the development system, image optimization only occurs when the website is deployed. When in development the original image is used. During the build process, the optimizer task creates an additional 4 versions of the source image, that are used along with `image srcset`s to cater to specific viewports and reduce network traffic.

### Stylesheets
Motion uses Sass for its styling. All stylesheets are currently stored in the source/stylesheets folder. Each functional component of the website has its own stylesheet and all stylesheets are included in the `site.css.scss` file that is included in the website's layout, making all styles available from any page. If you want to create your own styles, create a `scss` file inside the `stylesheets` folder and `import` it in the `site.css.scss` file like so: `@import "NAME_OF_STYLESHEET";`

# More advanced features / workflows

## Custom Markdown Tags
Motion is built around a custom Markdown parser making creatiion of new custom markdown tags a very easy process. The custom tags that are currently implemented are targeted towards embedded content, such as Youtube videos, Spotify and Soundcloud audio track and albums, etc. You can find the definition for these tags in the `custom_markdown_extensions_development.rb` and `custom_markdown_extensions_production.rb` files.
For example, the following Youtube tag enables you to use this syntax inside your Markdown document to embed a Youtube video and apply custom styliing, without having to copy the entire HTML snippet from Youtube.
By typing this in your Markdown: `[youtube-video youtube-video-link]` you get this when the page is rendered:
```html
<p>
  <div class="youtube-container column is-mobile center">
    <iframe width="100%" height="100%" src="https://www.youtube.com/embed/youtube-video-link"  \
    frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
    </iframe>
  </div>
</p>
```

## Helper Libraries
Motion has a number of helper functions already defined. They are located in the `lib` folder under the root of the project. Some of them are divided in development and production versions to better suit certain workflows. A good example is the responsive image helper that doesn't return responsive image `srcset`s when in development mode, because there are no optimized images yet, as they are created on build only. In order to include your custom helper libraries, create the helper file and include it in the `config.rb` in the `#Helpers Section`.




