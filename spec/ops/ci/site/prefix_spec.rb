require_relative '../../../../ops/ci/site/prefix'

RSpec.describe Prefix do
  describe '.prune' do
    it 'drops the prefix of a closed pull request' do
      expect(Prefix.prune('PR_NUMBER' => '7')).to eq(['7/'])
    end

    it 'drops the prefix of a deleted branch' do
      expect(Prefix.prune('DELETED_BRANCH' => 'feature/login')).to eq(['feature-login/'])
    end

    it 'drops nothing when main is deleted' do
      expect(Prefix.prune('DELETED_BRANCH' => 'main')).to eq([])
    end

    it 'drops nothing when badges is deleted' do
      expect(Prefix.prune('DELETED_BRANCH' => 'badges')).to eq([])
    end
  end
end
