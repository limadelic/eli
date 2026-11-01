require 'tmpdir'
require_relative '../../../../ops/ci/site/prefix'

RSpec.describe Prefix do
  describe '.prune' do
    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          Dir.mkdir('7')
          Dir.mkdir('feature-login')
          File.write('report.html', '')
          example.run
        end
      end
    end

    it 'drops nothing when a root file of the store is deleted' do
      expect(Prefix.prune('DELETED_BRANCH' => 'report.html')).to eq([])
    end

    it 'drops nothing when no directory of the store matches' do
      expect(Prefix.prune('DELETED_BRANCH' => 'gone')).to eq([])
    end

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
