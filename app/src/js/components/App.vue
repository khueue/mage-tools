<script lang="js">
export default {}
</script>

<template lang="pug">
#app
	transition(name="view-fade" mode="out-in")
		router-view
</template>

<style lang="scss" scoped>
.view-fade-enter-active,
.view-fade-leave-active {
	transition: opacity .15s ease;
}

.view-fade-enter,
.view-fade-leave-to {
	opacity: 0;
}
</style>
