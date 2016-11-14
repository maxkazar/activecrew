RSpec.shared_examples 'active_crew/combinable' do
  let(:name) { 'service/model/create' }
  let(:options) { { name: %w(test test1) } }
  let(:combine_commands) { { "#{name}" => options } }

  describe '#combine_command' do
    it 'combine options value into uniq array' do
      subject.combine_command name, name: 'test'
      subject.combine_command name, name: 'test'
      subject.combine_command name, name: 'test1'

      expect(subject.combine_commands).to eq combine_commands
    end
  end

  describe '#execute_combine_commands' do
    before { allow(subject).to receive(:combine_commands).and_return combine_commands }

    it 'execute all combine commands' do
      expect(subject).to receive(:command).with name, options
      subject.send :execute_combine_commands
    end
  end
end
