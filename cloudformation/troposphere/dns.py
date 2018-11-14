import troposphere
import troposphere.route53

CONFIG = {
	'public': {
		'hosted_zone_name': 'mage.khueue.com',
		'domain_names': [
			'mage.khueue.com',
		],
	},
	'target': {
		'domain_name': 'd2iev16oh3mkad.cloudfront.net',
		'cloudfront_hosted_zone_id': 'Z2FDTNDATAQYW2', # Fixed ID for CloudFront.
	},
}

template = troposphere.Template()

hosted_zone = troposphere.route53.HostedZone(
	'HostedZone',
	template=template,
	Name=CONFIG['public']['hosted_zone_name'] + '.',
)

record_sets = []

for domain in CONFIG['public']['domain_names']:
	for type in ['A', 'AAAA']:
		record_set = troposphere.route53.RecordSet(
			Name=domain + '.',
			Type=type,
			AliasTarget=troposphere.route53.AliasTarget(
				HostedZoneId=CONFIG['target']['cloudfront_hosted_zone_id'],
				DNSName=CONFIG['target']['domain_name'] + '.',
			),
		)
		record_sets.append(record_set)

record_set_group = troposphere.route53.RecordSetGroup(
	'RecordSetGroup',
	template=template,
	HostedZoneId=troposphere.Ref(hosted_zone),
	RecordSets=record_sets,
)

print template.to_json()
