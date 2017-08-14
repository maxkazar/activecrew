require 'spec_helper'

RSpec.describe ActiveCrew::Base do
  let(:invoker) { Invoker.new }

  subject { ActiveCrew::Base.new invoker }

  it_behaves_like 'active_crew/chainable'
  it_behaves_like 'active_crew/validatable'
  it_behaves_like 'active_crew/respondable'
  it_behaves_like 'active_crew/commandable'
  it_behaves_like 'active_crew/combinable'
  it_behaves_like 'active_crew/lockable'
end
