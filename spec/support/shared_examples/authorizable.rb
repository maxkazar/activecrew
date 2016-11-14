RSpec.shared_examples 'active_crew/authorizable' do
  describe '#execute' do
    context 'when authorized' do
      before { allow(subject).to receive(:can_execute?).and_return true }

      it 'execute without exception' do
        expect { subject.execute }.to_not raise_error
      end
    end

    context 'when unauthorized' do
      before { allow(subject).to receive(:can_execute?).and_return false }

      it 'raise AuthorizationError' do
        expect { subject.execute }.to raise_error(ActiveCrew::AuthorizationError)
      end
    end
  end
end
