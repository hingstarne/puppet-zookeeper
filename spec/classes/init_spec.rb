require 'spec_helper'

describe 'zookeeper' do

  context 'Supported OS - ' do
    ['Debian'].each do |osfamily|
      describe "#{osfamily} Standard installation" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_package('zookeeper').with_ensure('present') }
        it { should contain_service('zookeeper').with_ensure('running') }
      end

      describe "#{osfamily} Installation of a specific package version" do
        let(:params) { {
          :version => '1.0.42',
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_package('zookeeper').with_ensure('1.0.42') }
      end

      describe "#{osfamily} Removal of package installation" do
        let(:params) { {
          :ensure => 'absent',
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it 'should remove Package[zookeeper]' do should contain_package('zookeeper').with_ensure('absent') end
        it 'should stop Service[zookeeper]' do should contain_service('zookeeper').with_ensure('stopped') end
        it 'should not manage at boot Service[zookeeper]' do should contain_service('zookeeper').with_enable(nil) end
        it 'should remove zookeeper configuration file' do should contain_file('zookeeper.conf').with_ensure('absent') end
      end

      describe "#{osfamily} Service disabling" do
        let(:params) { {
          :service_ensure => 'stopped',
          :service_enable => false,
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it 'should stop Service[zookeeper]' do should contain_service('zookeeper').with_ensure('stopped') end
        it 'should not enable at boot Service[zookeeper]' do should contain_service('zookeeper').with_enable('false') end
      end

      describe "#{osfamily} Configuration via custom template" do
        let(:params) { {
          :config_file_template     => 'zookeeper/spec.conf',
          :config_file_options_hash => { 'opt_a' => 'value_a' },
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_file('zookeeper.conf').with_content(/This is a template used only for rspec tests/) }
        it 'should generate a template that uses custom options' do
          should contain_file('zookeeper.conf').with_content(/value_a/)
        end
      end

      describe "#{osfamily} Configuration via custom source file" do
        let(:params) { {
          :config_file_source => "puppet:///modules/zookeeper/spec.conf",
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_file('zookeeper.conf').with_source('puppet:///modules/zookeeper/spec.conf') }
      end

      describe "#{osfamily} Configuration via custom source dir" do
        let(:params) { {
          :config_dir_source => 'puppet:///modules/zookeeper/tests/',
          :config_dir_purge => true
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it { should contain_file('zookeeper.dir').with_source('puppet:///modules/zookeeper/tests/') }
        it { should contain_file('zookeeper.dir').with_purge('true') }
        it { should contain_file('zookeeper.dir').with_force('true') }
      end

      describe "#{osfamily} Service restart on config file change (default)" do
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it 'should automatically restart the service when files change' do
          should contain_file('zookeeper.conf').with_notify('Service[zookeeper]')
        end
      end

      describe "#{osfamily} Service restart disabling on config file change" do
        let(:params) { {
          :config_file_notify => '',
        } }
        let(:facts) {{
          :osfamily => osfamily,
        }}
        it 'should automatically restart the service when files change' do
          should contain_file('zookeeper.conf').without_notify
        end
      end

    end
  end

  context 'Unsupported OS - ' do
    describe 'Not supported operating systems should throw and error' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end

end

