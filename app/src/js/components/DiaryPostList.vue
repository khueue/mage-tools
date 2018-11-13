<script lang="js">
import firebase from '/js/firebase';
import db from '/js/firebase/db';

import DiaryPost from '/js/components/DiaryPost.vue';

export default {
	data() {
		return {
			entries: [],
			currentUser: null,
			unsubscriber: null,
			newEntry: null,
		};
	},
	components: {
		DiaryPost,
	},
	created() {
		const self = this;
		firebase.auth().onAuthStateChanged(function(user) {
			self.currentUser = null;
			self.entries = [];
			if (user) {
				self.currentUser = {
					uid: user.uid,
					email: user.email,
				};
				self.subscribeToFirestoreSnapshots();
			} else {
				self.unsubscribeToFirestoreSnapshots();
			}
		});
	},
	methods: {
		signInWithGoogle() {
			var provider = new firebase.auth.GoogleAuthProvider();
			firebase.auth().signInWithPopup(provider);
		},
		signOut() {
			firebase.auth().signOut();
		},
		saveEntry(entry) {
			const self = this;
			const entriesColl = db.collection('users').doc(self.currentUser.uid).collection('entries');
			if (entry.id) {
				entriesColl.doc(entry.id).set({
					message: entry.message,
					meta: entry.meta,
				}).then(function () {
					console.log('Set!');
				}).catch(function (error) {
					console.error(error);
				});
			} else {
				self.newEntry = null;
				entriesColl.add({
					message: entry.message,
					meta: entry.meta,
				}).then(function (doc) {
					console.log('Added!');
				}).catch(function (error) {
					console.error(error);
				});
			}
		},
		deleteEntry(entry) {
			const self = this;
			const entriesColl = db.collection('users').doc(self.currentUser.uid).collection('entries');
			entriesColl.doc(entry.id).delete()
			.then(function () {
				console.log('Deleted!');
			}).catch(function (error) {
				console.error(error);
			});
		},
		cancelNewPost(entry) {
			const self = this;
			self.newEntry = null;
		},
		editNewEntry() {
			const self = this;
			self.newEntry = {
				meta: {},
				isEditing: true,
				message: null,
			};
		},
		subscribeToFirestoreSnapshots() {
			const self = this;
			const entriesColl = db.collection('users').doc(self.currentUser.uid).collection('entries');
			self.unsubscriber = entriesColl.orderBy('meta.createdAt', 'desc').limit(100).onSnapshot(function(snapshot) {
				const entries = [];
				snapshot.forEach(function(snap) {
					const entry = self.newEntryFromSnapshot(snap);
					entries.push(entry);
				});
				self.entries = entries;
			}, function (error) {
				console.log(error);
			});
		},
		unsubscribeToFirestoreSnapshots() {
			const self = this;
			if (self.unsubscriber) {
				self.unsubscriber();
			}
		},
		newEntryFromSnapshot(snap) {
			const entry = {};

			entry.id = snap.id;

			// Use auto-generated version timestamp to help Vue
			// decide whether to re-render.
			const version = snap._document.version.timestamp;
			entry.renderKey = `${snap.id}.${version.seconds}.${version.nanoseconds}`;

			entry.message = snap.data().message;

			entry.meta = snap.data().meta;

			return entry;
		},
	},
};
</script>

<template lang="pug">
#app
	.hero.is-fullheight.is-dark
		.hero-head
			.container.is-pulled-right
				.field
					.control.sign-in-control
						transition(name="fade")
							.signed-out(key="signed-in" v-if="!currentUser")
								button.button(@click="signInWithGoogle") Sign in
							.signed-in(key="signed-out" v-else)
								button.button(@click="signOut") Sign out ({{ currentUser.email }})
		.hero-body
			.container(v-if="currentUser")
				button.button(@click="editNewEntry") Add new entry
				DiaryPost(
					v-if="newEntry"
					:entry="newEntry"
					@save="saveEntry"
					@delete-entry="deleteEntry"
					@cancel-post="cancelNewPost"
				)
				transition-group(v-if="entries.length > 0" name="entry-list")
					DiaryPost(
						v-for="entry in entries"
						:key="entry.renderKey"
						:entry="entry"
						@save="saveEntry"
						@delete-entry="deleteEntry"
					)
				.empty(v-else) No entries!
			.container(v-else)
				p You need to sign in!
		.hero-foot
</template>

<style lang="scss" scoped>
.sign-in-control {
	position: relative;
	button {
		position: absolute;
	}
}

.entry-list-enter-active,
.entry-list-leave-active {
	transition: all 0.5s;
}
.entry-list-enter,
.entry-list-leave-to {
	opacity: 0;
	// transform: translateY(30px);
}
</style>
