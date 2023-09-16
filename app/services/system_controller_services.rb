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
    class SystemControllerServices < ApplicationLesliServices
        
        # @overwrite
        # ...
        def index
            # get a matrix of controllers and actions
            c = SystemController.joins(:actions).select(
                "lesli_vault_system_controllers.name as id",
                "lesli_vault_system_controllers.name as controller",
                "lesli_vault_system_controllers.id as controller_id",
                "lesli_vault_system_controller_actions.name as action",
                "lesli_vault_system_controller_actions.id as action_id",
                "case lesli_vault_system_controller_actions.name
                    when 'index'   then 1
                    when 'show'    then 2
                    when 'new'     then 3
                    when 'edit'    then 4
                    when 'create'  then 5
                    when 'update'  then 6
                    when 'destroy' then 7
                    when 'options' then 8
                    else 9
                end as importance
                "
            )
            #.where("lesli_vault_system_controller_actions.name in ('index', 'create', 'update', 'show', 'destroy')")
            #.order("lesli_vault_system_controllers.name, importance, lesli_vault_system_controller_actions.name")
            .order("importance DESC")

            return c unless matrix

            cc = {}

            # convert the matrix to a hash of controllers with the available actions as values
            # example:
            #   my_controller: [my list of actions]
            c.each do |c|

                # create a uniq container for every action that belongs to a specific controller
                if cc[c[:controller]].blank?
                    cc[c[:controller]] = { 
                        id: c[:controller_id], 
                        name: c[:controller], 
                        actions: []
                    } 
                end

                # push every action to his specic controller
                cc[c[:controller]][:actions].push({ 
                    id: c[:action_id], 
                    action: c[:action]
                })
            end

            cc
        end

        # ...
        def options
            {
                categories: SystemController.categories.map {|k, _| { label: k, value: k }}
            }
        end
    end
end
