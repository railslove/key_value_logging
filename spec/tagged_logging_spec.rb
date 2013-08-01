require 'spec_helper'

describe KeyValueLogging::TaggedLogging do
  let(:output) { StringIO.new }
  before { logger.tagged(location: 'Cologne'){ logger.info('My Message') } }

  context 'default message style' do
    let(:logger) { KeyValueLogging::TaggedLogging.new(Logger.new(output)) }
    it { expect(output.string).to include('My Message') }
    it { expect(output.string).to include('location=Cologne') }
  end

  context 'raw message style' do
    let(:logger) { KeyValueLogging::TaggedLogging.new(Logger.new(output), :raw) }
    it { expect(output.string).to include(':message=>"My Message"') }
    it { expect(output.string).to include(':location=>"Cologne"') }
  end
end