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
    class DescriptorService < Lesli::ApplicationLesliService

        # @overwrite
        # @return {Object}
        # @description Finds a descriptor according the ID given
        def find id
            self.resource = self.current_user.account.descriptors.find_by_id(id)
            self
        end
    
        # @overwrite
        # @return [Array] Paginated index of users.
        # @description Return a paginated array of users, used mostly in frontend views
        def index

            descriptors = current_user.account.descriptors.where.not(
                :name => ["owner"]
            )
    
            # Count the amount of privileges assigned to every descriptor
            descriptors = descriptors.joins(%(
                left join  (
                    select
                        count(1) as total,
                        descriptor_id
                    from lesli_descriptor_privileges
                    --where apga.status = TRUE
                    group by descriptor_id
                ) as actions
                on actions.descriptor_id = lesli_descriptors.id
            ))

            descriptors = descriptors.select(
                :id,
                :name,
                :method,
                "coalesce(actions.total, 0) as privileges_count",
                Date2.new.date_time.db_timestamps("lesli_descriptors")
            )
            
            # skip native descriptors
            #descriptors = descriptors.where.not("descriptors.name in (?)", ["owner", "sysadmin", "profile"])
    
            # Filter results by search string
            # unless search_string.blank?
            #     descriptors = descriptors.where("(LOWER(descriptors.name) SIMILAR TO ?)", search_string)
            # end
    
            return descriptors
            .page(query[:pagination][:page])
            .per(query[:pagination][:perPage])
            .order("#{query[:order][:by]} #{query[:order][:dir]} NULLS LAST")
        end 
    
        # @overwrite
        # @return {Hash}
        # @description Retrives the descriptor with specific keys/attributes
        def show 
            { 
                :id => resource.id,
                :name => resource.name,
                :category => resource.category,
                :privileges => resource.privileges.joins(system_controller_action: :system_controller).select(
                    "descriptor_privileges.id",
                    "system_controllers.name as controlle_name",
                    "system_controller_actions.name as action_name",
                    "descriptor_privileges.created_at"
                )
            }
        end
    
        # @overwrite
        # @return {Object}
        # @param {params} Hash of the permitted attributes for a descriptor
        # @description Creates a new descriptor
        def create params
            descriptor = current_user.account.descriptors.new(params)

            if descriptor.save
                self.resource = descriptor
                # TODO: keep track of the activities
            else
                self.error(descriptor.errors.full_messages.to_sentence)
            end

            self
        end

        # @overwrite
        # @return {Object}
        # @param {params} Hash of the permitted attributes for a descriptor
        # @description Updates descriptor's attributes and saves logs if it went without problem
        def update params

            # TODO: keep track of the activities

            unless self.resource.update(params)
                self.error(self.resource.errors.full_messages.to_sentence)
            end

            self
        end

        # @overwrite
        # @return {Object}
        # @description Deletes the descriptor 
        def destroy

            # TODO: keep track of the activities

            unless self.resource.destroy
                self.error(self.resource.errors.full_messages.to_sentence)
            end

            self
        end    
    end
end
