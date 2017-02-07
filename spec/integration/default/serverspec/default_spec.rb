require 'spec_helper'

describe 'DockerContainer::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  it 'does something' do
    skip 'Replace this with meaningful tests'
  end
end
require_relative '../spec_helper'

describe 'buildContainerTask::default' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
    runner.converge(described_recipe)
  end

  it 'creates nginx config for default site' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/default').with(
        source: 'default.erb',
        owner: 'root',
        group: 'root',
        mode: '0644'
    )
  end
end