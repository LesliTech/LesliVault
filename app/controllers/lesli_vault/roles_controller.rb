=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module LesliVault
    class RolesController < ApplicationController

        #before_action :set_role, only: %i[ show update destroy ]

        #@return [HTML|JSON] HTML view for listing all roles or a Json that contains a list of all roles
        #    associated to this *account*
        #@description Retrieves and returns all roles associated to a *CloudHouse::Account*. The account
        #    is obtained directly from *current_user*. The HTTP request has to specify
        #    wheter the HTML or the JSON text should be rendered
        #@example
        #    # Executing this controller's action from javascript's frontend
        #    this.http.get(`127.0.0.1/house/roles`);
        def index
            respond_to do |format|
                format.html { }
                format.json {
                    respond_with_successful(RoleService.new(current_user, query).index)
                    #respond_with_pagination(RoleService.new(current_user, query).index)
                }
            end
        end

        # @return [HTML|Json] HTML view showing the requested role or a Json that contains the
        #     information of the role. If there is an error, an explanation message is sent
        # @description Retrieves and returns the requested roles. The id of the
        #     role is within the *params* attribute of the controller. The HTTP request has to specify
        #     wheter the HTML or the JSON text should be rendered. This is the only method that uses the role
        #     code instead of the ID for searching.
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let role_id = 1;
        #     this.http.get(`127.0.0.1/roles/${role_id}`);
        def show
            respond_to do |format|
                format.html {  }
                format.json {
                    return respond_with_not_found unless @role.found?

                    respond_with_successful(@role.show)
                }
            end
        end

        # @return [HTML] HTML view for creating a new role
        # @description returns an HTML view with a form so users can create a new role
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     this.url.go('/roles/new')
        def new
        end

        # @return [HTML] HTML view for editing the role
        # @description returns an HTML view with a form so users edit an existing role
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let role_id = 3;
        #     this.url.go(`/roles/${role_id}/edit`)
        def edit
        end

        # @return [Json] Json that contains wheter the creation of the role was successful or not.
        #     If it is not successful, it returns an error message
        # @description Creates a new role associated to the *current_user*'s *account*.
        # @example
        #     # Executing this controller's action from javascript's frontend
        #     let data = {
        #         role: {
        #             name: "Change Request"
        #         }
        #     };
        #     this.http.post('127.0.0.1/house/roles', data);
        def create

            role = RoleService.new(current_user).create(role_params)

            if role.successful?
                respond_with_successful(role.result) 
            else
                respond_with_error(role.errors_as_sentence)
            end
        end

        # @controller_action_param :name [String] The name of the role
        # @return [Json] Json that contains wheter the role was successfully updated or not.
        #     If it it not successful, it returns an error message
        # @description Updates an existing role associated to the *current_user*'s *account*.
        def update
            # Respond with 404 if role was not found
            return respond_with_not_found unless @role.found?

            # check if current user can work with role
            unless current_user.can_work_with_role?(@role.resource)
                return respond_with_error(I18n.t("core.roles.messages_danger_updating_role_object_level_permission_too_high"))
            end

            # Update role information
            @role.update(role_params)

            # check if the update went OK
            unless @role.successful?
                respond_with_error(@role.errors)
            end

            respond_with_successful(@role)
        end

        # @return [Json] Json that contains wheter the role was successfully deleted or not.
        #     If it it not successful, it returns an error message
        # @description Deletes an existing *role* associated to the *current_user*'s *account*.
        def destroy
            return respond_with_not_found unless @role.found?

            # Validation: check if the role has still associated users
            if @role.has_users?
                return respond_with_error(I18n.t("core.roles.messages_danger_users_assigned_validation"))
            end

            @role.destroy

            # Check if the deletion went ok
            unless @role.successful?
                return respond_with_error(@role.errors)
            end

            respond_with_successful
        end

        # @return [JSON]
        # @description Gets all the specific options for roles CRUD
        def options
            respond_with_successful(RoleService.new(current_user).options)
        end

        private

        # @return [void]
        # @description Sets the requested user based on the current_users's account
        # @example
        #     # Executing this method from a controller action:
        #     set_role
        #     puts @role
        #     # This will either display nil or an instance of Role
        def set_role
            @role = RoleServices.new(current_user).find(params[:id])
        end

        # @return [Parameters] Allowed parameters for the role
        # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
        #     Allowed params are detail_attributes: [:name, :active, :object_level_permission]
        # @example
        #     # suppose params contains {
        #     #    "role": {
        #     #        "name": "Admin",
        #     #        "word": Hello
        #     #    }
        #     #}
        #     filtered_params = role_params
        #     puts filtered_params
        #     # will remove all unpermitted attributes and only print {
        #     #    "name": "Admin",
        #     #}
        def role_params
            params.fetch(:role, {}).permit(
                :name,
                :active,
                :only_my_data,
                :default_path,
                :limit_to_path,
                :object_level_permission
            )
        end

    end
end
