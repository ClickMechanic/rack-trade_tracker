require 'spec_helper'

RSpec.describe Rack::TradeTracker::Cookie do
  let(:params_hash) { {campaign_id: 'ABCDEF', material_id: '123456', affiliate_id: 'ABC123', reference: 'ref'} }
  let(:parameters) { double :parameters, params_hash.merge(to_hash: params_hash) }
  let(:domain) { 'test.com' }
  let(:time_now) { Time.now }
  let(:digest) { Digest::MD5.hexdigest('CHK_ABCDEF::123456::ABC123::ref') }

  before { allow(Time).to receive(:now).and_return(time_now) }

  subject { Rack::TradeTracker::Cookie.new(domain,parameters) }

  it 'is named after the campaign_id' do
    expect(subject.name).to eq 'TT2_ABCDEF'
  end

  it 'generates a checksum' do
    expect(subject.checksum).to eq digest
  end

  it 'generates a UNIX timestamp' do
    expect(subject.timestamp).to eq time_now.to_i
  end

  describe '#value' do
    it 'combines material_id, affiliate_id, reference, checkSum and timeStamp' do
      expected = "123456::ABC123::ref::#{digest}::#{time_now.to_i}"
      expect(subject.value).to eq expected
    end
  end

  describe 'as_hash' do
    it 'includes the value' do
      expect(subject.as_hash[:value]).to eq subject.value
    end
    it 'includes the domain' do
      expect(subject.as_hash[:domain]).to eq ".#{domain}"
    end
    it 'includes the path' do
      expect(subject.as_hash[:path]).to eq '/'
    end
    it 'includes the expiry' do
      expect(subject.as_hash[:expires]).to eq time_now + 1.year
    end
  end
end
