class HomesController < ApplicationController
  require 'open-uri'
  def index
  end

  def manga_search
  end

  def search
    uri = URI.parse "http://mangafox.me/ajax/search.php"
    search_param = {term: params[:query]}
    uri.query = URI.encode_www_form( search_param )
    result = uri.open.read
    render json: result
  end

  def manga_detail
    link = "http://mangafox.me/manga/#{params[:title]}" 
    doc = Nokogiri.parse open(link)
    chapter_nodes = doc.xpath("//a[@class='tips']") || []
    chapters = []
    chapter_nodes.each do |chapter_node|
      title_node = chapter_node.at_xpath("./following-sibling::span[@class='title nowrap']/text()")
      title = title_node.text if title_node.present?
      chapters.push({title: title, link: chapter_node.attributes['href'].value.gsub('http://mangafox.me/manga/',''), link_id: chapter_node.text})
    end
    render json: chapters
  end

  def manga_chapter
    link = "http://mangafox.me/manga/#{params[:chapter]}" 
    chapter_link = link[0..link.rindex("/")]
    # request link
    doc = Nokogiri.parse open(link)
    previous_page = doc.at_xpath("//div[@id='chnav']/p[1]/a/@href")
    next_page = doc.at_xpath("//div[@id='chnav']/p[2]/a/@href")
    previous_page_link = previous_page.value.gsub('http://mangafox.me/manga/', '') if previous_page.present?
    next_page_link = next_page.value.gsub('http://mangafox.me/manga/', '')  if next_page.present?
    # get page number
    total_page = doc.at_xpath("//select[@class='m']/option[last()-1]/@value")
    image_links = []
    (1..total_page.value.to_i).each do |page_number|
      page = Nokogiri.parse open(chapter_link + page_number.to_s + ".html")
      node = page.at_xpath("//img[@id='image']/@src")
      image_links.push node.value if node.present?
    end
    render json: {images: image_links, previous_link: previous_page_link, next_link: next_page_link}
  end
end
