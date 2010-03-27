ActionController::Routing::RouteSet::Mapper.class_eval do

  protected

    # reuse the session routes and controller
    def imapable(routes, mapping)
      unless mapping.to.respond_to?(:authenticate)
        authenticatable(routes, mapping)
      end
    end

end