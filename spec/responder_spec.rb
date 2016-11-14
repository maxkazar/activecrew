require 'spec_helper'

RSpec.describe ActiveCrew::Responders do
  describe '.create' do
    context 'when responder exists' do
      let(:responder) { ActiveCrew::Responders::TestResponder }

      before do
        module ActiveCrew::Responders::TestResponder; end

        allow(subject).to receive(:responder).and_return :test
      end

      it 'create responder' do
        expect { subject.create }.to change(subject, :default).to(responder)
      end
    end

    context 'when responder does not exist' do
      before { allow(subject).to receive(:responder).and_return 'UnknownResponder'}

      it 'raise exception' do
        expect { subject.create }.to raise_error ArgumentError
      end
    end
  end
end
