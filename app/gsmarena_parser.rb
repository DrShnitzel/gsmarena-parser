require 'mechanize'
require 'byebug'

class GsmarenaParser
  GSMARENA_PAGE = 'http://www.gsmarena.com/'
  GSMARENA_MAKERS_PAGE = 'http://www.gsmarena.com/makers.php3'

  def initialize(params = {})
    @agent = Mechanize.new
    @params = params
  end

  def brands
    @agent.get(GSMARENA_MAKERS_PAGE)
    resp = []
    @agent.page.search('.st-text a').each do |a|
      title = a.children.first['alt']
      href = a['href']
      next unless title
      resp << { title: title, href: href }
    end
    resp
  end

  def phones
    @agent.get(GSMARENA_PAGE + @params[:brand_url])
    resp = []
    @agent.page.search('#review-body li').each do |li|
      href = li.children.first['href']
      title = li.css('span').text
      resp << { title: title, href: href }
    end
    threads = []
    mutex = Mutex.new
    @agent.page.search('.nav-pages a').each do |a|
      threads << Thread.new do
        new_phones = phones_from_page(a.attributes['href'].value)
        mutex.synchronize do
          resp += new_phones
        end
      end
    end
    threads.each(&:join)
    resp
  end

  def phone
    @agent.get(GSMARENA_PAGE + @params[:phone_url])
    resp = []
    @agent.page.search('#specs-list table').each do |table|
      table.search('tr').each do |tr|
        title = tr.search('.ttl').first
        next unless title
        title = title.text
        value = tr.search('.nfo').first.text
        title = table.search('th').first.text if title == ' '
        resp << { title: title, value: value }
      end
    end
    resp
  end

  def search
    @agent.get(GSMARENA_PAGE + 'results.php3?sFreeText=' + @params[:text])
    resp = []
    @agent.page.search('#review-body li').each do |li|
      href = li.children.first['href']
      title = li.css('span').text
      resp << { title: title, href: href }
    end
    resp
  end

  private

  def phones_from_page(page)
    agent = Mechanize.new
    agent.get(GSMARENA_PAGE + page)
    resp = []
    agent.page.search('#review-body li').each do |li|
      href = li.children.first['href']
      title = li.css('span').text
      resp << { title: title, href: href }
    end
    resp
  end
end
