require 'spec_helper'
require 'action_controller'
require 'active_crew/extender'

RSpec.describe ActiveCrew::Extender do
  let(:extend_class) { ActionController::Base }
  let(:current_user) { double :current_user }
  let(:session_id) { 'session_id' }
  let(:headers) { { 'x-session-token' => session_id} }

  subject { extend_class.new }

  describe '#command' do
    let(:command) { 'project/create' }
    let(:options) { { name: 'My Project' } }

    before do
      allow(subject).to receive(:current_user).and_return current_user
      allow(subject).to receive_message_chain('request.headers').and_return headers
    end

    it 'enqueue command' do
      expect(ActiveCrew::Backends).to receive(:enqueue).with(command, current_user, options: options, session: session_id, context: {} )
      subject.command command, options
    end
  end
end
