require 'spec_helper'

describe 'sentry' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "sentry class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('sentry') }
          it { is_expected.to contain_class('sentry::params') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'sentry class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('sentry') }.to raise_error(Puppet::Error, /Solaris \(Nexenta\) not supported/) }
    end
  end
end
