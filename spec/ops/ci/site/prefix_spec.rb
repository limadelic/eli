require_relative '../../../../ops/ci/site/prefix'

RSpec.describe Prefix do
  describe '.prune' do
    it 'drops the prefix of a closed pull request' do
      expect(Prefix.prune('PR_NUMBER' => '7')).to eq(['7/'])
    end
  end
end
