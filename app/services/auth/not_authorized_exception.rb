module Auth
  # thrown in the event that access to a resource is not authorized
  class NotAuthorizedException < RuntimeError

  end
end