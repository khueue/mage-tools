import db from '/js/firestore';
import * as moment from 'moment';

import Entry from '/js/entry';

export default {
	name: 'app',
	data() {
		return {
			entries: [],
		};
	},
	components: {
		Entry,
	},
	created() {
		const self = this;
		self.loadEntries();
	},
	methods: {
		loadEntries() {
			const self = this;
			// db.collection('entries').add({
			// 	text: "Trying to add entry from code",
			// 	meta: {
			// 		createdAt: moment.utc().format(),
			// 		updatedAt: moment.utc().format(),
			// 	},
			// });
			db.collection('entries').orderBy('meta.createdAt').onSnapshot(function(snapshot) {
				const entries = [];
				snapshot.forEach(function(snap) {
					const entry = {};
					entry.id = snap.id;
					entry.text = snap.data().text;
					entry.meta = snap.data().meta;
					entries.push(entry);
				});
				self.entries = entries;
			});
		},
	},
};
