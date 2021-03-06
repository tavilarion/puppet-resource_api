require 'spec_helper'

RSpec.describe Puppet::ResourceApi::ReadOnlyParameter do
  subject(:read_only_parameter) do
    described_class.new(type_name, data_type, attribute_name, resource_hash)
  end

  let(:type_name) { 'test_name' }
  let(:attribute_name) { 'some_parameter' }
  let(:data_type) { Puppet::Pops::Types::PStringType.new(nil) }
  let(:resource_hash) { { resource: {} } }

  describe '#new(type_name, data_type, attribute_name, resource_hash)' do
    it { expect { described_class.new(nil) }.to raise_error ArgumentError, %r{wrong number of arguments} }
    it { expect { described_class.new(type_name, data_type, attribute_name, resource_hash) }.not_to raise_error }
  end

  describe 'value munging and storage' do
    context 'when the value set attempt is performed' do
      it 'value set fails' do
        expect { read_only_parameter.value = 'value' }.to raise_error(
          Puppet::ResourceError,
          %r{Attempting to set `some_parameter` read_only attribute value to `value`},
        )
      end
    end

    context 'when value is not set' do
      it { expect(read_only_parameter.rs_value).to eq nil }
      it { expect(read_only_parameter.value).to eq nil }
    end

    context 'when value is already set' do
      before(:each) do
        read_only_parameter.instance_variable_set(:@value, 'value')
      end

      it { expect(read_only_parameter.rs_value).to eq 'value' }
      it { expect(read_only_parameter.value).to eq 'value' }
    end
  end
end
