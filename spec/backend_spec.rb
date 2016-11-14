require 'spec_helper'

RSpec.describe ActiveCrew::Backends do
  describe '.create' do
    context 'when backend exists' do
      let(:backend) { ActiveCrew::Backends::TestBackend }

      before do
        module ActiveCrew::Backends::TestBackend; end

        allow(subject).to receive(:backend).and_return :test
      end

      it 'create backend' do
        expect { subject.create }.to change(subject, :default).to(backend)
      end
    end

    context 'when backend does not exist' do
      before { allow(subject).to receive(:backend).and_return 'UnknownBackend'}

      it 'raise exception' do
        expect { subject.create }.to raise_error ArgumentError
      end
    end
  end
end
