require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe BugsnagData do
  after :each do
    # Remove stubs
    WebMock.reset!
  end

  describe 'Bugsnag API' do
    it 'should retrieve an account object' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '{"id":"1","name":"Test Account","created_at":"2013-08-30T03:00:11Z","updated_at":"2014-04-13T00:01:05Z","projects_url":"https://api.bugsnag.com/account/projects","account_creator":{"id":"123","email":"user123@test.com","name":"User 123","gravatar_id":"a123","gravatar_url":"https://secure.gravatar.com/avatar/a123","account_admin":false,"url":"https://api.bugsnag.com/users/123","projects_url":"https://api.bugsnag.com/users/123/projects","html_url":"https://bugsnag.com/accounts/test-account/collaborators/123/edit"},"billing_contact":{"id":"123","email":"user123@test.com","name":"User 123","gravatar_id":"a123","gravatar_url":"https://secure.gravatar.com/avatar/a123","account_admin":false,"url":"https://api.bugsnag.com/users/123","projects_url":"https://api.bugsnag.com/users/123/projects","html_url":"https://bugsnag.com/accounts/test-account/collaborators/123/edit"}}',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/account')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      account = bugsnag.account
      expect(account['id']).to eq('1')
      expect(account['name']).to eq('Test Account')
    end

    it 'should retrieve all the users associated with the account' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '[{"id":"123","email":"user123@test.com","name":"User 123","gravatar_id":"a123","gravatar_url":"https://secure.gravatar.com/avatar/a123","account_admin":false,"url":"https://api.bugsnag.com/users/123","projects_url":"https://api.bugsnag.com/users/123/projects","html_url":"https://bugsnag.com/accounts/acquia-hosting-eng/collaborators/123/edit"},{"id":"124","email":"user124@test.com","name":"User 124","gravatar_id":"a124","gravatar_url":"https://secure.gravatar.com/avatar/a124","account_admin":false,"url":"https://api.bugsnag.com/users/124","projects_url":"https://api.bugsnag.com/users/124/projects","html_url":"https://bugsnag.com/accounts/acquia-hosting-eng/collaborators/124/edit"}]',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/account/users')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      users = bugsnag.users
      expect(users[0]['id']).to eq('123')
      expect(users[0]['name']).to eq('User 123')
      expect(users[0]['email']).to eq('user123@test.com')

      expect(users[1]['id']).to eq('124')
      expect(users[1]['name']).to eq('User 124')
      expect(users[1]['email']).to eq('user124@test.com')
    end

    it 'should retrieve all the users associated with a project' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '[{"id":"123","email":"user123@test.com","name":"User 123","gravatar_id":"a123","gravatar_url":"https://secure.gravatar.com/avatar/a123","account_admin":false,"url":"https://api.bugsnag.com/users/123","projects_url":"https://api.bugsnag.com/users/123/projects","html_url":"https://bugsnag.com/accounts/acquia-hosting-eng/collaborators/123/edit"},{"id":"124","email":"user124@test.com","name":"User 124","gravatar_id":"a124","gravatar_url":"https://secure.gravatar.com/avatar/a124","account_admin":false,"url":"https://api.bugsnag.com/users/124","projects_url":"https://api.bugsnag.com/users/124/projects","html_url":"https://bugsnag.com/accounts/acquia-hosting-eng/collaborators/124/edit"}]',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/projects/789/users')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      project_users = bugsnag.project_users(789)
      expect(project_users[0]['id']).to eq('123')
      expect(project_users[0]['name']).to eq('User 123')
      expect(project_users[0]['email']).to eq('user123@test.com')

      expect(project_users[1]['id']).to eq('124')
      expect(project_users[1]['name']).to eq('User 124')
      expect(project_users[1]['email']).to eq('user124@test.com')
    end

    it 'should retrieve a specific user' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '{"id":"123","email":"user123@test.com","name":"User 123","gravatar_id":"a123","gravatar_url":"https://secure.gravatar.com/avatar/a123","account_admin":false,"url":"https://api.bugsnag.com/users/123","projects_url":"https://api.bugsnag.com/users/123/projects","html_url":"https://bugsnag.com/accounts/acquia-hosting-eng/collaborators/123/edit"}',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/users/123')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      user = bugsnag.user(123)
      expect(user['id']).to eq('123')
      expect(user['name']).to eq('User 123')
      expect(user['email']).to eq('user123@test.com')
    end

    it 'should retrieve all the projects associated with the account' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '[{"id":"788","name":"Project 788","type":"js","created_at":"2014-01-13T14:46:36Z","updated_at":"2014-04-11T14:09:02Z","release_stages":["production"],"api_key":"p788abc","errors":661,"url":"https://api.bugsnag.com/projects/788","errors_url":"https://api.bugsnag.com/projects/788/errors","events_url":"https://api.bugsnag.com/projects/788/events","html_url":"https://bugsnag.com/788/project-788","icon":"https://bugsnag.com/assets/frameworks/js-7990fbbc9ed76cbb4cf3ef94c38184d1.png"},{"id":"789","name":"Project 789","type":"sinatra","created_at":"2013-12-19T18:47:07Z","updated_at":"2014-02-26T16:17:00Z","release_stages":["development","deployment"],"api_key":"p789abc","errors":10,"url":"https://api.bugsnag.com/projects/789","errors_url":"https://api.bugsnag.com/projects/789/errors","events_url":"https://api.bugsnag.com/projects/789/events","html_url":"https://bugsnag.com/789/project-789","icon":"https://bugsnag.com/assets/frameworks/sinatra-8ec3e49424b23c00956c7179544c5326.png"}]',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/account/projects')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      projects = bugsnag.projects
      expect(projects[0]['id']).to eq('788')
      expect(projects[0]['name']).to eq('Project 788')
      expect(projects[0]['type']).to eq('js')

      expect(projects[1]['id']).to eq('789')
      expect(projects[1]['name']).to eq('Project 789')
      expect(projects[1]['type']).to eq('sinatra')
    end

    it 'should retrieve all the projects associated with a user' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '[{"id":"788","name":"Project 788","type":"js","created_at":"2014-01-13T14:46:36Z","updated_at":"2014-04-11T14:09:02Z","release_stages":["production"],"api_key":"p788abc","errors":661,"url":"https://api.bugsnag.com/projects/788","errors_url":"https://api.bugsnag.com/projects/788/errors","events_url":"https://api.bugsnag.com/projects/788/events","html_url":"https://bugsnag.com/788/project-788","icon":"https://bugsnag.com/assets/frameworks/js-7990fbbc9ed76cbb4cf3ef94c38184d1.png"},{"id":"789","name":"Project 789","type":"sinatra","created_at":"2013-12-19T18:47:07Z","updated_at":"2014-02-26T16:17:00Z","release_stages":["development","deployment"],"api_key":"p789abc","errors":10,"url":"https://api.bugsnag.com/projects/789","errors_url":"https://api.bugsnag.com/projects/789/errors","events_url":"https://api.bugsnag.com/projects/789/events","html_url":"https://bugsnag.com/789/project-789","icon":"https://bugsnag.com/assets/frameworks/sinatra-8ec3e49424b23c00956c7179544c5326.png"}]',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/user/123/projects')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      user_projects = bugsnag.users_projects(123)
      expect(user_projects[0]['id']).to eq('788')
      expect(user_projects[0]['name']).to eq('Project 788')
      expect(user_projects[0]['type']).to eq('js')

      expect(user_projects[1]['id']).to eq('789')
      expect(user_projects[1]['name']).to eq('Project 789')
      expect(user_projects[1]['type']).to eq('sinatra')
    end

    it 'should retrieve a specific project' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '{"id":"789","name":"Project 789","type":"sinatra","created_at":"2013-12-19T18:47:07Z","updated_at":"2014-02-26T16:17:00Z","release_stages":["development","deployment"],"api_key":"p789abc","errors":10,"url":"https://api.bugsnag.com/projects/789","errors_url":"https://api.bugsnag.com/projects/789/errors","events_url":"https://api.bugsnag.com/projects/789/events","html_url":"https://bugsnag.com/789/project-789","icon":"https://bugsnag.com/assets/frameworks/sinatra-8ec3e49424b23c00956c7179544c5326.png"}',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/projects/789')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      project = bugsnag.project(789)
      expect(project['id']).to eq('789')
      expect(project['name']).to eq('Project 789')
      expect(project['type']).to eq('sinatra')
    end

    it 'should retrieve a projects errors' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '[{"id":"abc123","last_message":"Uncaught TypeError: Cannot read property \'prototype\' of undefined","class":"TypeError","occurrences":3882,"release_stages":{"production":3882},"last_context":"/login","resolved":false,"first_received":"2014-01-24T21:42:03Z","last_received":"2014-04-15T03:49:20Z","users_affected":1879,"comments":0,"url":"https://api.bugsnag.com/errors/abc123","events_url":"https://api.bugsnag.com/errors/abc123/events","html_url":"https://bugsnag.com/test-account/project-123/errors/abc123","comments_url":"https://api.bugsnag.com/errors/abc123/comments"},{"id":"abc124","last_message":"this.items[0] is undefined","class":"TypeError","occurrences":1,"release_stages":{"production":1},"last_context":"/home","resolved":false,"first_received":"2014-04-15T03:44:46Z","last_received":"2014-04-15T03:44:44Z","users_affected":1,"comments":0,"url":"https://api.bugsnag.com/errors/abc124","events_url":"https://api.bugsnag.com/errors/abc124/events","html_url":"https://bugsnag.com/test-account/project-123/errors/abc124","comments_url":"https://api.bugsnag.com/errors/abc124/comments"},{"id":"abc125","last_message":"\'null\' is not an object (evaluating \'a.connection.close\')","class":"TypeError","occurrences":479,"release_stages":{"production":479},"last_context":"/page/1","resolved":false,"first_received":"2014-02-08T06:15:32Z","last_received":"2014-04-15T03:38:19Z","users_affected":222,"comments":0,"url":"https://api.bugsnag.com/errors/abc125","events_url":"https://api.bugsnag.com/errors/abc125/events","html_url":"https://bugsnag.com/test-account/project-123/errors/abc125","comments_url":"https://api.bugsnag.com/errors/abc125/comments"}]',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/projects/789/errors')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      project_errors = bugsnag.project_errors(789)
      expect(project_errors[0]['id']).to eq('abc123')
      expect(project_errors[0]['last_message'])
        .to eq("Uncaught TypeError: Cannot read property 'prototype' of undefined")
      expect(project_errors[0]['class']).to eq('TypeError')
      expect(project_errors[0]['occurrences']).to eq(3882)
      expect(project_errors[0]['last_context']).to eq('/login')
      expect(project_errors[0]['resolved']).to eq(false)
      expect(project_errors[0]['users_affected']).to eq(1879)
      expect(project_errors[0]['comments']).to eq(0)

      expect(project_errors[1]['id']).to eq('abc124')
      expect(project_errors[1]['last_message'])
        .to eq('this.items[0] is undefined')
      expect(project_errors[1]['class']).to eq('TypeError')
      expect(project_errors[1]['occurrences']).to eq(1)
      expect(project_errors[1]['last_context']).to eq('/home')
      expect(project_errors[1]['resolved']).to eq(false)
      expect(project_errors[1]['users_affected']).to eq(1)
      expect(project_errors[1]['comments']).to eq(0)

      expect(project_errors[2]['id']).to eq('abc125')
      expect(project_errors[2]['last_message'])
        .to eq("'null' is not an object (evaluating 'a.connection.close')")
      expect(project_errors[2]['class']).to eq('TypeError')
      expect(project_errors[2]['occurrences']).to eq(479)
      expect(project_errors[2]['last_context']).to eq('/page/1')
      expect(project_errors[2]['resolved']).to eq(false)
      expect(project_errors[2]['users_affected']).to eq(222)
      expect(project_errors[2]['comments']).to eq(0)
    end

    it 'should retrieve a projects events' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '[{"id":"def123","received_at":"2014-04-15T04:23:32Z","user_id":"1.1.1.1","context":"/login","meta_data":{"Request":{"url":"https://test.com/login"},"Device":{"browserName":"Firefox","browserVersion":"28.0.0","locale":"en-AU","osName":"Ubuntu","userAgent":"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:28.0) Gecko/20100101 Firefox/28.0"},"Event":{"millisecondsAgo":"-1396138274565101","target":"#document","type":"DOMContentLoaded"},"User":{"id":"1.1.1.1"}},"url":"https://api.bugsnag.com/events/def123","html_url":"https://bugsnag.com/test-account/project-123/errors/abc123?event_id=def123","exceptions":[{"class":"TypeError","message":"Drupal.ajax is undefined","stacktrace":[{"file":"https://test.com/sites/default/files/js/js_abc.js","line":573,"column":3,"method":null},{"file":"https://test.com/sites/default/files/js/js_def.js","line":30,"method":"ready"},{"file":"https://test.com/sites/default/files/js/js_ghi.js","line":38,"method":"c</u"}]}]}]',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/projects/789/events')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      project_events = bugsnag.project_events(789)
      expect(project_events[0]['id']).to eq('def123')
      expect(project_events[0]['user_id']).to eq('1.1.1.1')
      expect(project_events[0]['context']).to eq('/login')
    end

    it 'should retrieve an errors events' do
      response_content = {
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: '[{"id":"def123","received_at":"2014-04-15T04:23:32Z","user_id":"1.1.1.1","context":"/login","meta_data":{"Request":{"url":"https://test.com/login"},"Device":{"browserName":"Firefox","browserVersion":"28.0.0","locale":"en-AU","osName":"Ubuntu","userAgent":"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:28.0) Gecko/20100101 Firefox/28.0"},"Event":{"millisecondsAgo":"-1396138274565101","target":"#document","type":"DOMContentLoaded"},"User":{"id":"1.1.1.1"}},"url":"https://api.bugsnag.com/events/def123","html_url":"https://bugsnag.com/test-account/project-123/errors/abc123?event_id=def123","exceptions":[{"class":"TypeError","message":"Drupal.ajax is undefined","stacktrace":[{"file":"https://test.com/sites/default/files/js/js_abc.js","line":573,"column":3,"method":null},{"file":"https://test.com/sites/default/files/js/js_def.js","line":30,"method":"ready"},{"file":"https://test.com/sites/default/files/js/js_ghi.js","line":38,"method":"c</u"}]}]}]',
        status: 200
      }
      stub_request(:get, 'https://api.bugsnag.com/errors/abc123/events')
        .with(headers: { 'Authorization' => 'token testkey' })
        .to_return(response_content)

      bugsnag = BugsnagData.new('testkey')
      error_events = bugsnag.error_events('abc123')
      expect(error_events[0]['id']).to eq('def123')
      expect(error_events[0]['user_id']).to eq('1.1.1.1')
      expect(error_events[0]['context']).to eq('/login')
    end
  end
end
