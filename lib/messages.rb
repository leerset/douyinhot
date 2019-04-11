require 'constants'

# Module for messages.
module Messages

  # Tell the user that they are not authorized.
  UNAUTHORIZED = '未被授权的'.freeze

  # Tell the user there are parameters missing.
  MISSING_PARAMS = '参数丢失'.freeze

  # Tell the user that the are missing required API headers is missing.
  MISSING_API_HEADERS = 'API头部丢失'.freeze

  # Tell the user that their API key and device or user do not match.
  INVALID_APP_ID = '无效的APPID'.freeze

  # Tell the user the API header format is invalid.
  INVALID_HEADER_FORMAT = '无效的头部格式'.freeze

  # Confirm that the user wants to complete the action.
  CONFIRM_ACTION = '请确认?'.freeze

  CONFIRM_ACTION_DELETE = '确认删除?'.freeze
  # Tell the user they created a API key.
  CREATED = '记录已创建'.freeze

  # Tell the user they updated a API key.
  UPDATED = '记录已更新'.freeze

  # Tell the user they deleted a API key.
  DELETED = '记录已删除'.freeze

  # Tell the user the given object could not be found.
  NOT_FOUND = '找不到'.freeze

  # Tell the user the given user could not be found.
  USER_NOT_FOUND = '找不到用户'.freeze

end
