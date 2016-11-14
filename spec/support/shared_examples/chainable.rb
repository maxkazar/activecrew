RSpec.shared_examples 'active_crew/chainable' do
  let(:chain) { ['service/model/create', 'service/model/update'] }

  describe '.new' do
    subject { described_class.new invoker, chain: chain }

    it 'set chain' do
      expect(subject.chain).to eq chain
    end
  end

  describe '#commands' do
    before { allow(subject).to receive(:command) }

    it 'add commands to chain' do
      expect(subject).to receive(:add_to_chain).with(chain)
      subject.commands(*chain)
    end

    it 'execute command in chain' do
      expect(subject).to receive(:execute_chain)
      subject.commands(*chain)
    end
  end

  describe '#add_to_chain' do
    context 'when chain is empty' do
      before { subject.chain.clear }

      it 'push commands into chain' do
        expect { subject.send :add_to_chain, chain }
          .to change(subject, :chain)
          .from([])
          .to(chain)
      end
    end

    context 'when chain is not empty' do
      let(:initial_chain) { ['service/model/remove'] }

      before { subject.chain.replace initial_chain }

      it 'push commands into chain' do
        expect { subject.send :add_to_chain, chain }
          .to change(subject, :chain)
          .from(initial_chain)
          .to initial_chain + chain
      end
    end
  end

  describe '#execute_chain' do
    context 'when chain is empty' do
      before { subject.chain.clear }

      it 'does not execute command' do
        expect(subject).to_not receive(:command)
        subject.send :execute_chain
      end
    end

    context 'when chain is not empty' do
      let(:rest_chain) { chain[1..-1] }
      let(:options) { { value: 'test' } }

      before { subject.chain.replace chain }

      it 'execute first command with the rest of chain' do
        expect(subject)
          .to receive(:command)
          .with chain.first, options, chain: rest_chain

        subject.send :execute_chain, options
      end
    end

    context 'with parallel commands' do
      before { subject.chain.replace [chain] }

      it 'execute parallel command' do
        expect(subject).to receive(:command).twice
        subject.send :execute_chain
      end
    end
  end
end
