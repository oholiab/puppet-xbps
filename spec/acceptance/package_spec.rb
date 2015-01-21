require 'spec_helper_acceptance'
require 'open4'

describe "xbps_instance" do

  before(:all) do
    @template = 'package.pp.tmpl'
  end

  def get_instance(name)
    instances = []
    Open4.popen4("xbps-query #{name}") do |pid, stdin,stdout,stderr|
      stdin.close
      stdout.each_line { |line| instances << line.split(': ')[1] if line.match "pkgver" }
    end
    expect(instances.count).to eq(1)
    instances.first
  end

  describe 'should create a new instance' do

    before(:all) do
      @config = {
        :name => "bc",
        :ensure => 'present',
      }

      PuppetManifest.new(@template, @config).apply
      @instance = get_instance(@config[:name])
    end

    after(:all) do
    end

    it "with the specified name" do
      expect(@instance.split('-').first).to eq(@config[:name])
    end
  end
end
