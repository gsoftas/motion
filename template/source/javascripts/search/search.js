import React, { Component } from 'react';
import axios from 'axios';
import Post from './post';

class Search extends Component {
  constructor(props){
    super(props);

    this.state = {
      blogsIndex: [],
      searchTerm: '',
      filteredBlogs: [],
      errors: [],
      showFound: false,
      blogsFound: 0
    };
  };

  componentWillMount() {
    axios
      .get('/entries.json')
      .then(console.log("Index downloaded!"))
      .then((res) => {
        this.setState({ blogsIndex: res.data })
      }) 
  };

  handleChange = event => {
    this.setState({ searchTerm: event.target.value })
  }

  handleSubmit = event => {
    event.preventDefault();

    this.filterBlogs()
  }

  handleKeyUp = event => {
    if (event.keyCode === 13) {
      this.filterBlogs()
    }
  }

  filterBlogs = () => {
    const { blogsIndex, searchTerm } = this.state
    let filteredBlogs

    if (searchTerm.trim().length > 2) {
      filteredBlogs = blogsIndex.filter(blogEntry => {
        let blogEntryKeys = Object.keys(blogEntry)
        let found = {} 

        for(let i = 0; i <= blogEntryKeys.length; i++) {
          if(blogEntry[blogEntryKeys[i]]) {
            found = blogEntry[blogEntryKeys[i]].toLowerCase().match(searchTerm.toLowerCase().trim())

            if(found !== null) break
          }
        }
        return found
      })

      this.setState({ filteredBlogs })

      this.setState({ showFound: true })
      this.setState({ errors: [] })

    } else {
      this.setState({ errors: [ 'The search term must be over 2 characters long' ] })
      console.log(this.state.errors)
      this.setState({ showFound: false})
    }  
  }

  render(){
    return (
      
        <form onSubmit={this.handleSubmit}>
        <div className="search-container">
          <div id="search"> 
            <div className="search-box column is-8">
              <div className="error-messages">
                { this.state.errors.length > 0 &&
                  (<div className="message is-success" style={{marginBottom: '1rem'}}>
                  <span className="message-body">{this.state.errors}</span>
                  </div>) 
                }
              </div>
              <div className="field has-addons">
                <p className="control" style={ { width: '100%' } }>
                  <input type="text" 
                    value={this.state.searchTerm} 
                    onChange={this.handleChange} 
                    onKeyUp={this.handleKeyUp}
                    placeholder="Search..." 
                    className="input search-field" 
                    required={true} />
                </p>
                <p className="control">
                  <a className="button search-field" onClick={this.handleSubmit}>
                    <i className="fa fa-search" aria-hidden="true"></i>
                  </a>
                </p>
              </div>
            </div>
            { this.state.showFound && 
              <div className="search-results">
                <div className="has-text-centered has-text-grey">
                  <div className="strike" style={ { maxWidth: '90%' } }>
                      <span className="is-size-6">Search Results ({ this.state.filteredBlogs.length }) items found</span>
                  </div>
                </div>
                {
                  this.state.filteredBlogs.map(article => {
                    return <Post article={article} key={article.title}/>
                  })
                }
              </div>
            }
            </div>
          </div>
        </form>
      
    )
  }
}

export default Search;