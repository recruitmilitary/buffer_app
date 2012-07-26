$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'buffer_app'
require 'rspec'
require 'vcr'
require 'pry'
require 'cgi'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :fakeweb
  c.filter_sensitive_data('<ACCESS_TOKEN>')  { ENV['BUFFER_ACCESS_TOKEN'] }
  c.filter_sensitive_data('<PROFILE_ID>') { ENV['BUFFER_PROFILE_ID'] }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end

class Hash
  def except(*keys)
    keys.each { |key| delete key }
    self
  end
end
