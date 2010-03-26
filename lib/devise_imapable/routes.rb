ActionController::Routing::RouteSet::Mapper.class_eval do

  protected

    # reuse the session routes and controller
    def imapable(routes, mapping)
      unless mapping.to.included_modules.include?(Devise::Models::Authenticatable)
        authenticatable(routes, mapping)
      end
    end

end