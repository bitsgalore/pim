gem 'rack-test', '~>0.3.0'
require 'rack/test'

gem 'webrat', '~>0.4.2'
require 'webrat'

# setup the app
app_file = File.join(File.dirname(__FILE__), '../../app.rb')
require app_file

$:.unshift File.join(File.dirname(__FILE__), '../../lib')
require 'validation'

Pim::App.app_file = app_file

Webrat.configure do |config|
  config.mode = :sinatra
end

require 'spec/expectations'

Pim::App.set :environment, :test

require 'nokogiri'

World do
  
  def app
    Pim::App
  end
  
  def fixture_xml name
    file = File.join(File.dirname(__FILE__), '..', 'fixtures', name)
    open(file) { |io| io.read }
  end
  
  include Rack::Test::Methods  
  include Webrat::Methods
  include Webrat::Matchers  
end
