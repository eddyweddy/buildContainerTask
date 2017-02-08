
require_relative '../../spec_helper'



describe 'buildContainerTask::default' do


  context 'verify converge will pass with default' do
    let(:user) { 'www' }
    let(:base) { '/etc/www' }
    let(:app_name) { 'app_name' }
    let(:subdirs) { %w(dir1 dir2 dir3) }
    let(:files) { %w(file1 file2 file3) }
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04') do |node|
        node.override['nginx']['user'] = user
        node.override['nginx']['app']['base'] = base
        node.override['nginx']['app']['name'] = app_name
        node.override['nginx']['app']['subdirectories'] = subdirs
        node.override['nginx']['app']['files'] = files
      end
      runner.converge(described_recipe)

    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs multiple packages' do
      expect(chef_run).to install_apt_package(%w(nginx net-tools ufw))
    end

    it 'creates base app dir' do
      expect(chef_run).to create_directory("#{base}/#{app_name}")
    end

    it 'creates app subdir 1' do
      expect(chef_run).to create_directory("#{base}/#{app_name}/dir1")
    end

    it 'creates app subdir 2' do
      expect(chef_run).to create_directory("#{base}/#{app_name}/dir2")
    end

    it 'installs sinatra gem' do
      expect(chef_run).to install_gem_package('sinatra')
    end

    it 'deploys app file 1' do
      expect(chef_run).to create_cookbook_file("#{base}/#{app_name}/file1")
    end

    it 'deploys app file 2' do
      expect(chef_run).to create_cookbook_file("#{base}/#{app_name}/file2")
    end

  end
end
