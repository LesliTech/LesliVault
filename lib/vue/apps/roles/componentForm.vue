<script setup>
/*

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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onMounted, watch, computed, inject } from "vue"
import { useRouter, useRoute } from "vue-router"


// · import lesli stores
import { useRole } from "../../stores/role"


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()


// · 
const translations = {
    core: {
        shared: I18n.t('core.shared'),
        roles: I18n.t('core.roles')
    }
}


// · 
onMounted(() => {
    if (route.params.id) {
        storeRole.fetchRole(route.params.id)
    } else {
        storeRole.$reset()
    }
    storeRole.getOptions()
})


// · 
function submitRole() {

    // role id exists, then just update the role
    if (storeRole.role.id) {
        return storeRole.putRole()
    }

    return storeRole.postRole()
}


// · 
function isObjectLevelPermissionSelected(olp) {
    return storeRole.role.object_level_permission == olp
}

</script>
<template>
    <lesli-form @submit="submitRole">

        <!-- Role name -->
        <div class="field">
            <label class="label">
                Name
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <input v-model="storeRole.role.payload.name" class="input" type="text" required />
            </div>
        </div>

        <!-- Role Description -->
        <div class="field">
            <label class="label">
                Description
            </label>
            <div class="control">
                <input v-model="storeRole.role.payload.description" class="input" type="text" />
            </div>
        </div>

        <!-- Role default path -->
        <div class="field">
            <label class="label">Default path</label>
            <div class="control">
                <input v-model="storeRole.role.payload.path_default" class="input" type="text" :placeholder="translations.core.roles.view_placeholder_default_path_at_login">
            </div>
            <p class="help">Default path to redirect after login.</p>
        </div>

        <hr />

        <!-- Role limited to path -->
        <div class="field">
            <label class="label">
                Limited?
            </label>
            <div class="control">
                <div class="select">
                    <lesli-select 
                        v-model="storeRole.role.payload.path_limited"
                        :options="[{
                            label: translations.core.roles.view_text_limit_to_path,
                            value: true
                        }, {
                            label: translations.core.roles.view_text_allow_all_paths,
                            value: false
                        }]">
                    </lesli-select>
                </div>
            </div>
            <p class="help">Always redirect role to the default path</p>
        </div>

        <!-- Role is isolated -->
        <div class="field">
            <label class="label">
                Isolated?
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <div class="select">
                    <lesli-select 
                        v-model="storeRole.role.payload.isolated"
                        :options="[{
                            label: translations.core.roles.view_text_restrict_data_access,
                            value: true
                        }, {
                            label: translations.core.roles.view_text_allow_to_see_all_the_data,
                            value: false
                        }]">
                    </lesli-select>
                </div>
            </div>
            <p class="help">Force the role to query only the data that belongs to the current user</p>
        </div>

        <!-- Enable/disable role -->
        <div class="field">
            <label class="label">
                Status
                <sup class="has-text-danger">*</sup>
            </label>
            <div class="control">
                <div class="select">
                    <lesli-select 
                        v-model="storeRole.role.payload.active"
                        :options="[{
                            label: translations.core.roles.view_text_active,
                            value: true
                        },{
                            label: translations.core.roles.view_text_disabled,
                            value: false
                        }]">
                    </lesli-select>
                </div>
            </div>
        </div>

        <hr>

        <!-- Object level permission -->
        <div class="field">
            <label class="label">
                Hierarchical level
                <sup class="has-text-danger">*</sup>
            </label>
            <ul class="hierarchical_level_selector">
                <li :class="['hover', 'p-1', { 'has-background-info has-text-light' : isObjectLevelPermissionSelected(olp.level) }]"
                    v-for="(olp, index) in storeRole.options.object_level_permissions" :key="index"
                    v-on:click="storeRole.role.payload.object_level_permission = olp.level">
                    <p class="icon-text">
                        <span class="icon">
                            <span class="material-icons">
                                {{ isObjectLevelPermissionSelected(olp.level) ? 'check_box' : 'check_box_outline_blank' }}
                            </span>
                            <i :class="['fas', isObjectLevelPermissionSelected(olp.level) ? 'fa-check' : 'fa-chevron-right']"></i>
                        </span>
                        <span>
                            {{ `${translations.core.roles.view_text_level || 'Level' } ${ index + 1 }` }}
                            <i v-if="olp.roles.length">- {{ olp.roles.map(role => role.name).join(', ') }}</i>
                        </span>
                    </p>
                </li>
            </ul>
        </div>

        <hr>

        <div class="field is-grouped">
            <div class="control">
                <lesli-button main icon="save" :loading="storeRole.role.loading">
                    Save
                </lesli-button>      
            </div>
        </div>
    </lesli-form>
</template>
