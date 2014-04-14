require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'webmock/rspec'

describe BugsnagData do
  after :each do
    # Remove stubs
    WebMock.reset!
  end

  describe "Bugsnag API Calls" do
    it "should retrieve an account object" do
      response_content = {
        :headers => {'Content-Type' => 'application/json; charset=utf-8'},
        :body => '{"id":"1","name":"Acquia Hosting Eng"}',
        :status => 200
      }
      stub_request(:get, "https://api.bugsnag.com/account").with(:headers => {'Authorization'=>'token testkey'}).to_return(response_content)

      bugsnag = BugsnagData.new("testkey")
      account = bugsnag.account
      expect(account["id"]).to eq(1)
      expect(account["name"]).to eq("Acquia Hosting Eng")
    end
  end
end
