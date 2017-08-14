RSpec.shared_examples 'active_crew/lockable' do
  describe '#locked?' do
    let(:model) { double :locker }
    let(:locker) { 'enable' }

    before do
      allow(model).to receive(:locker).and_return locker
      allow(subject).to receive(:deserialize_locker).and_return model
    end

    context 'when model locked' do
      before { subject.context[:locker] = { value: 'disable' } }

      it { expect(subject.locked?).to be true }
    end

    context 'when model unlocked' do
      before { subject.context[:locker] = { value: locker } }

      it { expect(subject.locked?).to be false }
    end
  end
end
