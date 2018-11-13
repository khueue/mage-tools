<script lang="js">
export default {
	data() {
		return {
			potency: 1,
			targets: 1,
			availableTargets: [1, 2, 4, 8, 16, 32, 64, 128],
			toggles: [],
		};
	},
	computed: {
		requiredSuccesses() {
			let succs = 0;
			succs += this.calcSuccessesForPotency();
			succs += this.calcSuccessesForTargets();
			return succs;
		},
		requiredExtraDots() {
			let dots = 0;
			dots += this.calcExtraDotsForExtras();
			return dots;
		},
		requiredManaCost() {
			let cost = 0;
			cost += this.calcManaCost();
			return cost;
		},
	},
	methods: {
		calcSuccessesForPotency() {
			return parseInt(this.potency);
		},
		calcSuccessesForTargets() {
			let succs = 0;
			let targets = parseInt(this.targets);
			while (targets > 1) {
				succs += 1;
				targets = targets / 2;
			}
			return succs;
		},
		calcExtraDotsForExtras() {
			let dots = 0;
			if (this.toggles.includes('bestow')) {
				dots += 1;
			}
			return dots;
		},
		calcManaCost() {
			let cost = 0;
			if (this.toggles.includes('hallow')) {
				cost -= 1;
			}
			if (this.toggles.includes('cloak')) {
				cost += 1;
			}
			return cost;
		},
	},
};
</script>

<template lang="pug">
.hero
	.hero-head
		.container
			.columns.is-centered
				.column.is-half
					h1.title Ritual Spell
	.hero-body
		.container
			.columns.is-centered
				.column.is-10
					.columns#configuration
						.column
							.box
								b-field( label="Potency")
									b-input(v-model.number="potency")

								b-field( label="Targets")
									b-select(v-model.number="targets")
										option(
											v-for="t in availableTargets"
											:key="t"
											:value="t"
											:selected="t == 1"
										) {{ t }}

								b-field( label="Duration")
									b-input

								b-field( label="Hang Time")
									b-input

						.column.is-4
							.box
								b-field
									b-checkbox(v-model="toggles" native-value="bestow") Bestow
								b-field
									b-checkbox(v-model="toggles" native-value="hallow") Hallow
								b-field
									b-checkbox(v-model="toggles" native-value="cloak") Cloak
								b-field
									b-checkbox(v-model="toggles" native-value="sympathetic") Sympathetic
								b-field
									b-checkbox(v-model="toggles" native-value="nonruling") Non-ruling
								b-field
									b-checkbox(v-model="toggles" native-value="aggravated") Aggravated

					.box
						h2.subtitle Result

						p Successes: {{ requiredSuccesses }}
						p Mana Cost: {{ requiredManaCost }}
						p Dot Penalty: {{ requiredExtraDots }}
</template>

<style lang="scss" scoped>
#configuration {
	.box {
		height: 100%;
	}
}
h1.title {
	margin-top: 0.5em;
	margin-bottom: -0.5em;
	text-align: center;
}
</style>
