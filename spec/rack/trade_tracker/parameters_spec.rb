require 'spec_helper'

RSpec.describe Rack::TradeTracker::Parameters do
  let(:request) { double :request, params: params }
  subject { Rack::TradeTracker::Parameters.build(request.params) }

  context 'when request includes campaignID parameter' do
    let(:params) { {'campaignID' => 'a-campaign-id',
                    'materialID' => 'a-material-id',
                    'affiliateID' => 'an-affiliate-id',
                    'redirectURL' => 'www.your-proper-url.com',
                    }}

    it 'extracts the parameters correctly' do
      params.each do |key, value|
        expect(subject.send(key.underscore)).to eq value
      end
    end

    context 'with a missing parameter' do
      before { params.delete('materialID') }
      
      it 'renders empty string for the missing parameter' do
        expect(subject.material_id).to eq ''
      end
    end
  end
  
  context 'when request includes tt parameter' do
    (1..4).each do |num_params|
      context "with #{num_params} values" do
        let(:provided_params) { Rack::TradeTracker::Parameters::Delimited::PERMITTED_PARAMS[0..(num_params - 1)] }
        let(:params) { {'tt' => num_params.times.map(&:to_s).join('_'), 'r' => 'www.your-proper-url.com'} }

        it 'extracts the parameters correctly' do
          provided_params.each_with_index do |param, index|
            expect(subject.send(param.underscore)).to eq index.to_s
          end
        end

        it 'extracts the redirect url' do
          expect(subject.redirect_url).to eq 'www.your-proper-url.com'
        end
      end
    end
  end
end
