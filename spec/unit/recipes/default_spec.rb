require_relative '../../spec_helper'

describe 'buildContainerTask::default' do

  context 'verify converge will pass with default' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)

    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
