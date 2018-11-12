import firebase from './';

const db = firebase.firestore();

db.settings({
	timestampsInSnapshots: true,
});

export default db;
