<script lang="js">
export default {};
</script>

<template lang="pug">
.hero
	.hero-head
	.hero-body
		.container
			.columns.is-centered
		aside.menu
			p.menu-label Mage
			ul.menu-list
				li
					router-link(to="/ritual") Ritual Spell
	.hero-foot
</template>

<style lang="scss" scoped></style>
