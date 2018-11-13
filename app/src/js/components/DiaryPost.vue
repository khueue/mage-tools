<script lang="js">
import * as moment from 'moment';

export default {
	props: {
		entry: {
			type: Object,
			required: true,
		},
	},
	data() {
		return {
			...this.entry,
			isEditing: !this.entry.id,
			draftMessage: this.entry.message,
		};
	},
	computed: {
		isNew() {
			return !this.id;
		},
		hasBeenEdited() {
			return this.meta.createdAt !== this.meta.updatedAt;
		},
		updatedAtRelative() {
			return moment.utc(this.meta.updatedAt).fromNow();
		},
		updatedAtPretty() {
			return moment.utc(this.meta.updatedAt).format('YYYY-MM-DD HH:mm');
		},
		createdAtPretty() {
			return moment.utc(this.meta.createdAt).format('YYYY-MM-DD HH:mm');
		},
	},
	methods: {
		edit() {
			this.isEditing = true;
		},
		cancelEdit() {
			this.isEditing = false;
			this.$emit('cancel-post', this);
		},
		save() {
			this.isEditing = false;
			this.message = this.draftMessage.trim();
			const now = moment.utc().format();
			if (!this.meta.createdAt) {
				this.meta.createdAt = now;
			}
			this.meta.updatedAt = now;
			this.$emit('save', this);
		},
		deleteEntry() {
			this.$emit('delete-entry', this);
		},
	},
	directives: {
		focus: {
			inserted(el) {
				el.focus();
			}
		},
	},
};
</script>

<template lang="pug">
.columns.entry
	.column.is-one-quarter
		p {{ createdAtPretty }}
		p(v-show="hasBeenEdited" :title="updatedAtPretty") (updated: {{ updatedAtRelative }})
	.column(v-on:dblclick="edit")
		.viewing(v-if="!isEditing")
			p {{ message }}
		.editing(v-else)
			.field
				.control
					textarea.textarea(v-model="draftMessage" v-focus="true" @keyup.esc="cancelEdit") {{ draftMessage }}
			.field
				.control
					button.button.is-primary(@click="save") Save
					button.button(@click="cancelEdit") Cancel
					button.button.is-danger.is-pulled-right(v-if="!isNew" @click="deleteEntry") Delete
</template>

<style lang="scss" scoped>
</style>
