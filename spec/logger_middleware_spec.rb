require 'spec_helper'
require 'rack/test'

describe KeyValueLogging::LoggerMiddleware do
  include Rack::Test::Methods

  let(:output) { StringIO.new }
  let(:config) { nil }

  let(:app) do
    Rails.logger = KeyValueLogging::TaggedLogging.new(Logger.new(output))
    middleware_config = config
    Rack::Builder.new do
      use KeyValueLogging::LoggerMiddleware, middleware_config
      run lambda { |env|
        [200, { 'Content-Type' => 'text/plain' }, ['Hello World!']]
      }
    end
  end

  context 'config by request attribute' do
    let(:config) { { params: :params } }
    before { get '/test?hello=world' }
    it { expect(output.string).to include('params={"hello"=>"world"}') }
  end

  context 'config by proc' do
    let(:config) { { params: ->(request) { request.params } } }
    before { get '/test?hello=world' }
    it { expect(output.string).to include('params={"hello"=>"world"}') }
  end

  context 'config with invalid configuration' do
    let(:config) { { invalid: ['test'] } }
    before { get '/test?hello=world' }
    it { expect(output.string).to include('invalid=test') }
  end
end