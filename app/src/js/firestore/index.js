import * as firebase from 'firebase/app';
import 'firebase/firestore';

import APP_CONFIG from '/js/app-config';

try {
	firebase.initializeApp(APP_CONFIG.firebase);
} catch (error) {
	// Skip error showing up when doing Hot Module Reloading.
	if (error.code !== 'app/duplicate-app') {
		console.error('Firebase initialization error', error.stack);
		throw error;
	}
}

const db = firebase.firestore();
db.settings({
	timestampsInSnapshots: true,
});

export default db;
