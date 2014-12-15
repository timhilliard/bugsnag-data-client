# bugsnag-data-client

Interact with the Bugsnag Data REST API.

[![Build Status](https://travis-ci.org/timhilliard/bugsnag-data-client.svg?branch=master)](https://travis-ci.org/timhilliard/bugsnag-data-client)

## API calls

    require 'bugsnag_data'
    bugsnag = BugsnagData.new("BUGSNAG_API_KEY")
    bugsnag.account
    bugsnag.users
    bugsnag.project_users(PROJECT_ID)
    bugsnag.user(USER_ID)
    bugsnag.projects
    bugsnag.user_projects(USER_ID)
    bugsnag.project(PROJECT_ID)
    bugsnag.project_errors(PROJECT_ID)
    bugsnag.project_events(PROJECT_ID)
    bugsnag.error_events(ERROR_ID)

## Use the API docs

For more - you should be able to find the latest at
[https://bugsnag.com/docs/api](https://bugsnag.com/docs/api) if you are a
Bugsnag customer.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Commit.
* Send me a pull request. Bonus points for topic branches.
