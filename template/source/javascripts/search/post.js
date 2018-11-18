import React from 'react';

const Post = ({ article }) => (

  <article className="search-result-item">
    <a className="search-result-thumbnail" href={article.url} style={ { backgroundImage: `url(${article.cover_image})` } }></a>
    <div className="search-result-content">
      <h2 className="search-result-content-title"><a href={article.url}>{article.title} ({ article.blog })</a></h2>
      <div className="search-result-meta">
        <span className="search-result-meta-date">{ article.date }</span>
        <p className="search-result-summary">{ article.summary }</p>
      </div>
    </div>
  </article>
);

export default Post



