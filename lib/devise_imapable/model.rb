require 'devise_imapable/strategy'

module Devise
  module Models
    # Imapable Module, responsible for validating the user credentials via an imap server and
    # checking authenticity of a user while signing in.
    #
    # Examples:
    #
    #    User.authenticate('email@test.com', 'password123')  # returns authenticated user or nil
    #    User.find(1).valid_password?('password123')         # returns true/false
    #
    module Imapable
      def self.included(base)
        # should assert that authenticatable is not included
        base.class_eval do
          extend ClassMethods

          attr_accessor :password
        end
      end

      # Set password and password confirmation to nil
      def clean_up_passwords
        self.password = nil
      end

      # def update_with_password(params={})
      #   # have a look into this later
      # end

      # Verifies whether an +incoming_authentication_token+ (i.e. from single access URL)
      # is the user authentication token.
      def valid_imap_authentication?(password)
        Devise::ImapAdapter.valid_credentials?(self.email, password)
      end

      module ClassMethods
        # Authenticate a user based on configured attribute keys. Returns the
        # authenticated user if it's valid or nil.
        def authenticate_with_imap(attributes={})
          return unless attributes[:email].present?
          conditions = attributes.slice(:email)
          resource = find_or_initialize_for_authentication(conditions)

          if resource.try(:valid_imap_authentication?, attributes[:password])
             resource.new_record? ? create(conditions) : resource
          end
        end


      protected

        # Find first record based on conditions given (ie by the sign in form).
        # Overwrite to add customized conditions, create a join, or maybe use a
        # namedscope to filter records while authenticating.
        # Example:
        #
        #   def self.find_for_authentication(conditions={})
        #     conditions[:active] = true
        #     find(:first, :conditions => conditions)
        #   end
        #
        def find_or_initialize_for_authentication(conditions)
          unless conditions[:email] && conditions[:email].include?('@')
            conditions[:email] = "#{conditions[:email]}@#{Devise.default_email_suffix}"
          end
          find(:first, :conditions => conditions) || new(conditions)
        end
      end
    end
  end
end
