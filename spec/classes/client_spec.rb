require 'spec_helper'

describe 'sentry::client' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('sentry::client') }
          it { is_expected.to contain_class('sentry::client::install').that_comes_before('sentry::client::config') }
          it { is_expected.to contain_class('sentry::client::config') }

          it { is_expected.to contain_file('/etc/sentry/conf/sentry-site.xml') }
          it { is_expected.to contain_package('sentry').with_ensure('present') }
        end
      end
    end
  end
end
