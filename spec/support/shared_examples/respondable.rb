RSpec.shared_examples 'active_crew/respondable' do
  describe '#respond_with' do
    let(:model) { double :model }

    it 'respond with command model' do
      expect(ActiveCrew::Responders)
        .to receive(:respond_with)
        .with(subject.name, subject.invoker, subject.context, model)

      subject.respond_with model
    end
  end
end
