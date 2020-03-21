require 'rails_helper'

RSpec.describe GraphqlDevise::OperationSanitizer do
  describe '.call' do
    subject { described_class.call(default: default, custom: custom, only: only, skipped: skipped) }

    let(:op_class1) { Class.new }
    let(:op_class2) { Class.new }
    let(:op_class3) { Class.new }

    context 'when the operations passed are mutations' do
      let(:custom)   { {} }
      let(:skipped)  { [] }
      let(:only)     { [] }
      let(:default)  { { operation1: op_class1, operation2: op_class2 } }

      context 'when no other option besides default is passed' do
        it { is_expected.to eq(default) }
      end

      context 'when there are custom operations' do
        let(:custom) { { operation1: op_class3, bad_operation: GraphQL::Schema::Resolver } }

        it { is_expected.to eq(operation1: op_class3, operation2: op_class2) }
      end

      context 'when there are only operations' do
        let(:only) { [:operation1] }

        it { is_expected.to eq(operation1: op_class1) }
      end

      context 'when there are skipped operations' do
        let(:skipped) { [:operation2] }

        it { is_expected.to eq(operation1: op_class1) }
      end
    end
  end
end
