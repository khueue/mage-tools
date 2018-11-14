import Vue from 'vue';
import VueRouter from 'vue-router';
import Buefy from 'buefy';
import 'buefy/dist/buefy.css';

Vue.use(Buefy);
Vue.use(VueRouter);
Vue.config.productionTip = false;

import App from '/js/components/App.vue';
import DiaryPostList from '/js/components/DiaryPostList.vue';
import RitualSpell from '/js/components/RitualSpell.vue';

const router = new VueRouter({
	mode: 'history',
	routes: [
		{
			path: '/',
			component: DiaryPostList,
		},
		{
			path: '/ritual',
			component: RitualSpell,
		},
		{
			path: '*',
			redirect: '/',
		},
	],
});

window.app = new Vue({
	router,
	render(h) {
		return h(App);
	},
});

window.app.$mount('#app');
