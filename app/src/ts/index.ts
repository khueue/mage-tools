import hello from './message/message';
console.log(hello({}, ["meee again", 6665]));

import m from 'mithril';

var FancyComponent = {
	view: function() {
		return m(".fancy", "Hello world")
	},
	onbeforeremove: function(vnode) {
		vnode.dom.classList.add("exit");
		return new Promise(function(resolve) {
			vnode.dom.addEventListener("animationend", resolve)
		});
	},
}

var on = true

var Toggler = {
	view: function() {
		return [
			m("button", {onclick: function() {on = !on}}, "Toggle"),
			on ? m(FancyComponent) : null,
		]
	}
}

m.mount(document.body, Toggler)
