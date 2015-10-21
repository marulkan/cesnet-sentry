require 'spec_helper'

describe 'sentry::server' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('sentry::server') }
          it { is_expected.to contain_class('sentry::server::install').that_comes_before('sentry::server::config') }
          it { is_expected.to contain_class('sentry::server::config') }
          it { is_expected.to contain_class('sentry::server::service').that_subscribes_to('sentry::server::config') }

          it { is_expected.to contain_file('/etc/sentry/conf/sentry-site.xml') }
          it { is_expected.to contain_service('sentry-store') }
          it { is_expected.to contain_package('sentry-store').with_ensure('present') }
        end
      end
    end
  end
end
