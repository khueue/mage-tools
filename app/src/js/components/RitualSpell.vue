<script lang="js">
export default {
	data() {
		return {
			potency: 1,
			targets: 1,
			targetsOptions: [1, 2, 4, 8, 16, 32, 64, 128, 256],
			hangTime: null,
			hangTimeOptions: [
				{ value: null, pretty: 'None', default: true },
				{ value: 'scene', pretty: 'Scene' },
				{ value: 'days1', pretty: '1 day' },
				{ value: 'days2', pretty: '2 days' },
				{ value: 'days4', pretty: '4 days' },
				{ value: 'days6', pretty: '6 days' },
				{ value: 'days8', pretty: '8 days' },
				{ value: 'days10', pretty: '10 days' },
				{ value: 'days12', pretty: '12 days' },
				{ value: 'days14', pretty: '14 days' },
			],
			duration: null,
			durationOptions: [
				{ value: null, pretty: 'None', default: true },
				{ value: 'transitory-turns-1', pretty: 'Transitory, 1 turn' },
				{ value: 'transitory-turns-2', pretty: 'Transitory, 2 turns' },
				{ value: 'transitory-turns-3', pretty: 'Transitory, 3 turns' },
				{ value: 'transitory-turns-5', pretty: 'Transitory, 5 turns' },
				{ value: 'transitory-turns-10', pretty: 'Transitory, 10 turns' },
				{ value: 'prolonged-scene', pretty: 'Prolonged, scene' },
				{ value: 'prolonged-hours-2', pretty: 'Prolonged, 2 hours' },
				{ value: 'prolonged-hours-12', pretty: 'Prolonged, 12 hours' },
				{ value: 'prolonged-days-1', pretty: 'Prolonged, 1 day' },
				{ value: 'prolonged-days-2', pretty: 'Prolonged, 2 days' },
				{ value: 'advanced-scene', pretty: 'Advanced, scene' },
				{ value: 'advanced-hours-2', pretty: 'Advanced, 2 hours' },
				{ value: 'advanced-days-2', pretty: 'Advanced, 2 days' },
				{ value: 'advanced-weeks-1', pretty: 'Advanced, 1 week' },
				{ value: 'advanced-months-1', pretty: 'Advanced, 1 month' },
				{ value: 'advanced-indefinite', pretty: 'Advanced, indefinite' },
				{ value: 'advanced-months-2', pretty: 'Advanced, 2 months' },
			],
			toggles: [],
		};
	},
	computed: {
		requiredSuccesses() {
			let total = 0;
			total += this.calcSuccessesForPotency();
			total += this.calcSuccessesForTargets();
			total += this.calcSuccessesForDuration();
			total += this.calcSuccessesForHangTime();
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
		calcSuccessesForDuration() {
			switch (this.duration) {
				case null: return 0;
				case 'transitory-turns-1': return 0;
				case 'transitory-turns-2': return 1;
				case 'transitory-turns-3': return 2;
				case 'transitory-turns-5': return 3;
				case 'transitory-turns-10': return 4;
				case 'prolonged-scene': return 0;
				case 'prolonged-hours-2': return 1;
				case 'prolonged-hours-12': return 2;
				case 'prolonged-days-1': return 3;
				case 'prolonged-days-2': return 4;
				case 'advanced-scene': return 0;
				case 'advanced-hours-2': return 1;
				case 'advanced-days-2': return 2;
				case 'advanced-weeks-1': return 3;
				case 'advanced-months-1': return 4;
				case 'advanced-indefinite': return 5;
				case 'advanced-months-2': return 5;
				default:
					alert('Not implemented');
					throw new Error('Unknown Duration');
			}
		},
		calcSuccessesForHangTime() {
			switch (this.hangTime) {
				case null: return 0;
				case 'scene': return 2;
				case 'days1': return 3;
				case 'days2': return 4;
				case 'days4': return 5;
				case 'days6': return 6;
				case 'days8': return 7;
				case 'days10': return 8;
				case 'days12': return 9;
				case 'days14': return 10;
				default:
					alert('Not implemented');
					throw new Error('Unknown Hang Time');
			}
		},
		calcExtraDotsForExtras() {
			let total = 0;
			if (this.toggles.includes('bestow')) {
				total += 1;
			}
			if (this.duration) {
				if (this.duration.startsWith('advanced-')) {
					total += 1;
				}
			}
			return total;
		},
		calcManaCost() {
			let total = 0;
			if (this.duration) {
				if (this.duration.startsWith('advanced-')) {
					total += 1;
				}
			}
			if (this.hangTime) {
				total += 1;
			}
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
											v-for="x in targetsOptions"
											:key="x"
											:value="x"
											:selected="x == 1"
										) {{ x }}

								b-field(label="Duration")
									b-select(v-model="duration")
										option(
											v-for="x in durationOptions"
											:key="x.value"
											:value="x.value"
											:selected="x.default"
										) {{ x.pretty }}

								b-field(label="Hang Time")
									b-select(v-model="hangTime")
										option(
											v-for="x in hangTimeOptions"
											:key="x.value"
											:value="x.value"
											:selected="x.default"
										) {{ x.pretty }}

						.column.is-4
							.box
								b-field(label="Extras")
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
