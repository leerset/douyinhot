# Module for constants.
module Constants

  # Number of minutes before inactive session expires.
  SESSION_LEN_IN_MINUTES = 30

  NOTIFICATION_BADGE_MAX = 100

  # Number of minutes before showing the session expiration countdown modal.
  SESSION_COUNTDOWN_MODAL_TIMEOUT = 28

  # Define maximum string length in bytes.
  MAX_STRING_LEN = 255

  # Define maximum text length in bytes.
  MAX_TEXT_LEN = 65_535

  # Define maximum large text length in bytes.
  # The mysql max is 16MB, but we are enforcing a lower limit.
  MAX_LARGE_TEXT_LEN = 1.megabyte

  # Define the max value for an integer.
  MAX_INT = 2_147_483_647

  # Set UUID length.
  UUID_LEN = 36

  # Define the default number of studies to display per page on the study list
  # table.
  DEFAULT_STUDIES_PER_PAGE = 25

end
