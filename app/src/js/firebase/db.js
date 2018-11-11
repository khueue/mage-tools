import firebase from '/js/firebase';

const db = firebase.firestore();
db.settings({
	timestampsInSnapshots: true,
});

export default db;
