import Vue from 'vue';
import Buefy from 'buefy';
import 'buefy/dist/buefy.css';

Vue.use(Buefy);
Vue.config.productionTip = false;

import App from '/js/app';

window.app = new Vue({
	el: '#app',
	render: function(h) {
		return h(App);
	},
});
