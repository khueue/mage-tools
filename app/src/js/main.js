import Vue from 'vue';
import Buefy from 'buefy';
import 'buefy/dist/buefy.css';

Vue.use(Buefy);
Vue.config.productionTip = false;

import DiaryPostList from '/js/components/DiaryPostList.vue';

window.app = new Vue({
	el: '#app',
	render: function(h) {
		return h(DiaryPostList);
	},
});
