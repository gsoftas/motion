module Metadata
  # Returns a string with the summary of the current page
  # Used in the Page Meta Partial

  def page_meta_description(current_page)
    current_page.data.summary || data.site.description
  end
end