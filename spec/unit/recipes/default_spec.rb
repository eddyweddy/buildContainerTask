
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

    it 'installs multiple packages' do
      expect(chef_run).to install_apt_package(%w(nginx net-tools ufw))
    end

    it 'creates simpleSinatra dir' do
      expect(chef_run).to create_directory('/var/www/simpleSinatra')
    end

    it 'creates public dir' do
      expect(chef_run).to create_directory('/var/www/simpleSinatra/public')
    end

    it 'creates tmp dir' do
      expect(chef_run).to create_directory('/var/www/simpleSinatra/tmp')
    end

    it 'installs sinatra gem' do
      expect(chef_run).to install_gem_package('sinatra')
    end

    it 'deploys config.ru' do
      expect(chef_run).to create_cookbook_file('/var/www/simpleSinatra/config.ru')
    end

  end
end
