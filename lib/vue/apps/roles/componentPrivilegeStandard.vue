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


// · import lesli stores
import { useRole } from "../../stores/role"
import { useDescriptor } from "../../stores/descriptor"


// · initialize/inject plugins
const msg = inject("msg")
const url = inject("url")


// · 
const storeRole = useRole()
const storeDescriptor = useDescriptor()


// · list, index, show, create, edit, delete
const columnDescriptors = [{
    field: 'name',
    label: 'Name'
},{
    field: 'index',
    label: 'Index',
    align: 'center'
},{
    field: 'show',
    label: 'Show',
    align: 'center'
},{
    field: 'create',
    label: 'Create',
    align: 'center'
},{
    field: 'update',
    label: 'Update',
    align: 'center'
},{
    field: 'destroy',
    label: 'Delete',
    align: 'center'
}]


// · 
function updateDescriptor(descriptor) {
    storeRole.updateDescriptor(descriptor)
}

</script>
<template>
    <lesli-table 
        :columns="columnDescriptors"
        :records="storeRole.descriptors">
        <template #head(index)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        format_list_numbered
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(show)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        visibility
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(create)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        add
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(update)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        edit
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>
        <template #head(destroy)="{ column }">
            <span class="icon-text">
                <span class="icon">
                    <span class="material-icons">
                        delete
                    </span>
                </span>
                <span>{{ column.label }}</span>
            </span>
        </template>

        <template #name="{ record }">
            <p>{{ record.name }}</p>
            <p><small>/{{ record.controller }}</small></p>
        </template>
        <template #list="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.list.active" @change="updateDescriptor(record.list)">
            </lesli-toggle>
        </template>
        <template #index="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.index.active" @change="updateDescriptor(record.index)">
            </lesli-toggle>
        </template>
        <template #show="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.show.active" @change="updateDescriptor(record.show)">
            </lesli-toggle>
        </template>
        <template #create="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.create.active" @change="updateDescriptor(record.create)">
            </lesli-toggle>
        </template>
        <template #update="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.update.active" @change="updateDescriptor(record.update)">
            </lesli-toggle>
        </template>
        <template #destroy="{ record, value }">
            <lesli-toggle v-if="value != null" v-model="record.destroy.active" @change="updateDescriptor(record.destroy)">
            </lesli-toggle>
        </template>
    </lesli-table>
</template>
