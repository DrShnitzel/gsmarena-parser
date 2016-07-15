require 'mechanize'

class MechanizeParser
  def initialize(params = {})
    @agent = Mechanize.new
    @params = params
  end

  def brands
    raise 'Method #brands must be implemented'
  end

  def phones
    raise 'Method #phones must be implemented'
  end

  def phone
    raise 'Method #phone must be implemented'
  end

  def search_phones
    raise 'Method #search_phones must be implemented'
  end

  private

  def get(url)
    @agent.get url
  end

  def search(selector)
    @agent.page.search(selector)
  end
end
