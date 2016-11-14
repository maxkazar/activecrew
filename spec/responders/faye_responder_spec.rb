require 'spec_helper'

RSpec.describe ActiveCrew::Responders::FayeResponder do
  describe '.respond' do
    let(:invoker) { double :invoker, id: 1, channel: 'channel', name: 'user', email: 'user@email.com' }
    let(:name) { 'command' }
    let(:context) { { session: 'session' } }
    let(:model) { { name: 'test' } }

    before do
      allow(subject).to receive(:status).and_return :success
      allow(subject).to receive :serialize_invoker
      allow(subject).to receive :serialize
      allow(subject).to receive(:config).and_return({})
    end

    it 'send request to fayre' do
      expect(subject).to receive(:request)

      subject.respond name, invoker, context, model
    end
  end
end
