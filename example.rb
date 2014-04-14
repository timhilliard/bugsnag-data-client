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
