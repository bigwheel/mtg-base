class SearchResult
  def initialize params
    @doc = Nokogiri::HTML(open(SearchUrl.new(params).concat))
  end
  def number
    @number ||= _number
  end
  private
  def _number
    span_tag = @doc.at_xpath("//div[@class='contentTitle']" +
                             "[contains(text(), 'Search:')]/span")
    span_tag.at_xpath('i').unlink # remove a child <i> ~ </i> node
    match_data = span_tag.content.strip.match(/\((\d+)\)/)
    match_data[1].to_i
  end
end
