require 'byebug'
require_relative 'mechanize_parser'

class GsmarenaParser < MechanizeParser
  GSMARENA_PAGE = 'http://www.gsmarena.com/'
  GSMARENA_MAKERS_PAGE = GSMARENA_PAGE + 'makers.php3'
  GSMARENA_SEARCH_PAGE = GSMARENA_PAGE + 'results.php3?sFreeText='

  def brands
    get GSMARENA_MAKERS_PAGE
    search('.st-text a').each_with_object([]) do |item, acc|
      title = item.children.first['alt']
      href = item['href']
      next unless title
      acc << { title: title, href: href }
    end
  end

  def phones
    get(GSMARENA_PAGE + @params[:brand_url])
    # Get all pages from pagination
    pages = search('.nav-pages a').map { |a| a['href'] }
    pages << (GSMARENA_PAGE + @params[:brand_url])
    parse_pages_in_threads(pages)
  end

  def phone
    get(GSMARENA_PAGE + @params[:phone_url])
    search('#specs-list table').each_with_object([]) do |item, acc|
      item.search('tr').each do |tr|
        spec = collect_spec(tr, item)
        next unless spec
        acc << spec
      end
    end
  end

  def search_phones
    get(GSMARENA_SEARCH_PAGE + @params[:text])
    search('#review-body li').each_with_object([]) do |item, acc|
      href = item.children.first['href']
      title = item.css('span').text
      acc << { title: title, href: href }
    end
  end

  private

  def collect_spec(tr, item)
    title = tr.search('.ttl').first
    return unless title
    title = title.text
    value = tr.search('.nfo').first.text
    title = item.search('th').first.text if title == ' '
    { title: title, value: value }
  end

  def parse_pages_in_threads(pages)
    @resp = []
    threads = []
    mutex = Mutex.new
    pages.each { |page| threads << create_thread(page, mutex) }
    threads.each(&:join)
    @resp
  end

  def create_thread(page, mutex)
    Thread.new do
      new_phones = phones_from_page(page)
      mutex.synchronize { @resp += new_phones }
    end
  end

  def phones_from_page(page)
    agent = Mechanize.new
    agent.get(GSMARENA_PAGE + page)
    agent.page.search('#review-body li').each_with_object([]) do |li, acc|
      href = li.children.first['href']
      title = li.css('span').text
      acc << { title: title, href: href }
    end
  end
end
