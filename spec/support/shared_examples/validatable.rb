RSpec.shared_examples 'active_crew/validatable' do
  describe '#execute' do
    it 'validate' do
      expect(subject).to receive(:validate)
      subject.execute
    end
  end
end
