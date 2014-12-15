#
# Author:: Tim Hilliard (<timhilliard@gmail.com>)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'httparty'

# Top level class for dealing with Bugsnag specific exceptions
class BugsnagDataExceptions
  # Exception class for dealing with failed requests
  class RequestFailed < RuntimeError; end
  # Exception class for dealing with requests that return not found by the API
  class NotFound < RequestFailed; end
  # Exception class for dealing with authorization failed requests
  class AuthorizationFailed < RequestFailed; end
  # Exception class for dealing with poorly formatted requests
  class BadRequest < RequestFailed; end
end

# Class for retrieving data from the Bugsnag API.
class BugsnagData
  include HTTParty

  attr_accessor :options

  base_uri 'https://api.bugsnag.com'

  # Creates a new base object for interacting with Bugnsags's REST API
  #
  # @param [String] api_key
  #   Your Bugsnag API key
  #
  def initialize(api_key)
    @options = { headers: { 'Authorization' => "token #{api_key}" } }
  end

  ##
  # Get Account details
  ##
  # Get details for the currently authenticated Account.
  #
  # See: https://bugsnag.com/docs/api/accounts#get-account-details
  #
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def account(params = {})
    make_get_request('/account', params)
  end

  ##
  # List your Account's Users
  ##
  # Get a list of all Users with access to the currently authenticated Bugsnag
  # Account.
  #
  # See: https://bugsnag.com/docs/api/users#list-your-account-s-users
  #
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def users(params = {})
    make_get_request('/account/users', params)
  end

  ##
  # List a Project's Users
  ##
  # Get a list of Users with access to the specified Project.
  #
  # See: https://bugsnag.com/docs/api/users#list-a-project-s-users
  #
  # @param [String] project_id
  #   A project ID
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def project_users(project_id, params = {})
    make_get_request("/projects/#{project_id}/users", params)
  end

  ##
  # Get User details
  ##
  # Get the details about a Bugsnag user, including name and email address.
  #
  # See: https://bugsnag.com/docs/api/users#get-user-details
  #
  # @param [String] user_id
  #   A user ID
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def user(user_id, params = {})
    make_get_request("/users/#{user_id}", params)
  end

  ##
  # List your Account's Projects
  ##
  # Get the details about a Bugsnag user, including name and email address.
  #
  # See: https://bugsnag.com/docs/api/projects#list-your-account-s-projects
  #
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def projects(params = {})
    make_get_request('/account/projects', params)
  end

  ##
  # List a User's Projects
  ##
  # Get a list of Projects that the specified Bugsnag User has access to.
  #
  # See: https://bugsnag.com/docs/api/projects#list-a-user-s-projects
  #
  # @param [String] user_id
  #   A user ID
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def users_projects(user_id, params = {})
    make_get_request("/user/#{user_id}/projects", params)
  end

  ##
  # Get Project Details
  ##
  # Get the details of the given Bugsnag Project.
  #
  # See: https://bugsnag.com/docs/api/projects#get-project-details
  #
  # @param [String] project_id
  #   A project ID
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def project(project_id, params = {})
    make_get_request("/projects/#{project_id}", params)
  end

  ##
  # List a Project's Errors
  ##
  # Get a list of all errors (grouped exceptions) for the given Bugsnag Project.
  #
  # See: https://bugsnag.com/docs/api/errors#list-a-project-s-errors
  #
  # @param [String] project_id
  #   A project ID
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def project_errors(project_id, params = {})
    make_get_request("/projects/#{project_id}/errors", params)
  end

  ##
  # List a Project's Events
  ##
  # Get a list of all events (individual crashes) for the given Bugsnag Project.
  #
  # See: https://bugsnag.com/docs/api/events#list-a-project-s-events
  #
  # @param [String] project_id
  #   A project ID
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def project_events(project_id, params = {})
    make_get_request("/projects/#{project_id}/events", params)
  end

  ##
  # List an Error's Events
  ##
  # Get a list of all events (individual crashes) grouped under the given
  # Bugsnag Error.
  #
  # See: https://bugsnag.com/docs/api/events#list-an-error-s-events
  #
  # @param [String] error_id
  #   An error ID
  # @param [Hash] params
  #   A hash of parameters to pass to the request.
  #
  def error_events(error_id, params = {})
    make_get_request("/errors/#{error_id}/events", params)
  end

  private

  def make_get_request(path, params = {})
    parse_response(self.class.get(path, prepare_params(params)))
  end

  def make_post_request(path, params = {})
    parse_response(self.class.post(path, prepare_params(params)))
  end

  def make_put_request(path, params = {})
    parse_response(self.class.put(path, prepare_params(params)))
  end

  def make_delete_request(path, params = {})
    parse_response(self.class.delete(path, prepare_params(params)))
  end

  def prepare_params(params = {})
    params[:headers] ||= {}
    params[:headers].merge!(options[:headers])
    params
  end

  def parse_response(response)
    case response.headers['status']
    when '404 Not Found'
      fail BugsnagDataExceptions::NotFound, 'Not Found'
    when '401 Unauthorized'
      fail BugsnagDataExceptions::AuthorizationFailed, 'Authorization Failed'
    when '400 Bad Request'
      fail BugsnagDataExceptions::BadRequest, 'Bad Request'
    end
    response.parsed_response
  end
end
