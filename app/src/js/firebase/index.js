import * as firebase from 'firebase/app';
import 'firebase/firestore';
import 'firebase/auth';

const FIREBASE_CONFIG = {
	apiKey: 'AIzaSyCN3tc7_t9iXegR_z2TqqRSYlXXP8F1vnc',
	authDomain: 'khueue-com.firebaseapp.com',
	projectId: 'khueue-com',
};

try {
	firebase.initializeApp(FIREBASE_CONFIG);
} catch (error) {
	if (error.code === 'app/duplicate-app') {
		// Skip error showing up when using Hot Module Reloading.
	} else {
		console.error('Firebase initialization error', error.stack);
		throw error;
	}
}

export default firebase;
