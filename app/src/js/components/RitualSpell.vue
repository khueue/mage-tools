<script lang="js">
export default {
	data() {
		return {
			potency: 1,
			targets: 1,
			allTargets: [1, 2, 4, 8, 16, 32, 64, 128, 256],
			toggles: [],
		};
	},
	computed: {
		requiredSuccesses() {
			let total = 0;
			total += this.calcSuccessesForPotency();
			total += this.calcSuccessesForTargets();
			return total;
		},
		requiredExtraDots() {
			let total = 0;
			total += this.calcExtraDotsForExtras();
			return total;
		},
		requiredManaCost() {
			let total = 0;
			total += this.calcManaCost();
			return total;
		},
		isVulgar() {
			return this.calcVulgarity();
		},
	},
	methods: {
		calcSuccessesForPotency() {
			return parseInt(this.potency);
		},
		calcSuccessesForTargets() {
			let total = 0;
			let targets = parseInt(this.targets);
			while (targets > 1) {
				total += 1;
				targets = targets / 2;
			}
			return total;
		},
		calcExtraDotsForExtras() {
			let total = 0;
			if (this.toggles.includes('bestow')) {
				total += 1;
			}
			return total;
		},
		calcManaCost() {
			let total = 0;
			if (this.toggles.includes('hallow')) {
				total -= 1;
			}
			if (this.toggles.includes('cloak')) {
				total += 1;
			}
			if (this.toggles.includes('sympathetic')) {
				total += 1;
			}
			if (this.toggles.includes('aggravated')) {
				total += 1;
			}
			if (this.toggles.includes('bestow')) {
				total += 1;
			}
			if (this.toggles.includes('nonruling')) {
				total += 1;
			}
			return total;
		},
		calcVulgarity() {
			if (this.toggles.includes('sympathetic')) {
				return true;
			}
			return false;
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
								b-field(label="Potency")
									b-input(v-model.number="potency")

								b-field(label="Targets")
									b-select(v-model.number="targets")
										option(
											v-for="t in allTargets"
											:key="t"
											:value="t"
											:selected="t == 1"
										) {{ t }}

								b-field(label="Duration")
									b-input

								b-field(label="Hang Time")
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
						p Vulgar: {{ isVulgar }}

	.hero-foot
		.container
			.columns.is-centered
				.column.is-10
					code mage-tools 0.0.1
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

.hero-foot {
	text-align: right;
	code {
		color: gray;
	}
}
</style>
