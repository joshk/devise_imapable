ActionController::Routing::RouteSet::Mapper.class_eval do

  protected

    # reuse the session routes and controller
    alias_method :imap_authenticate, :authenticate

end