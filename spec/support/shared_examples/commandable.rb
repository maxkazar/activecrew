RSpec.shared_examples 'active_crew/commandable' do
  describe '#command' do
    let(:name) { 'service/model/create' }
    let(:options) { { name: 'test'} }

    it 'enqueue command' do
      expect(ActiveCrew::Backends)
        .to receive(:enqueue)
        .with(name, subject.invoker, options: options)

      subject.command name, options
    end
  end
end
