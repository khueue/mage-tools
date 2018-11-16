import troposphere
import troposphere.cloudfront
import troposphere.s3

import awacs
import awacs.s3

CONFIG = {
	'app_bucket': {
		'name': 'khueue-mage-tools-app',
	},
	'pipeline_bucket': {
		'name': 'khueue-mage-tools-pipeline',
		'object_lifetime_days': 30,
	},
	'log_bucket': {
		'name': 'khueue-mage-tools-logs',
		'object_lifetime_days': 30,
	},
}

template = troposphere.Template()

log_bucket = troposphere.s3.Bucket(
	'LogBucket',
	template=template,
	BucketName=CONFIG['log_bucket']['name'],
	AccessControl='LogDeliveryWrite',
	LifecycleConfiguration=troposphere.s3.LifecycleConfiguration(
		Rules=[
			troposphere.s3.LifecycleRule(
				Id='DeleteOldObjects',
				Status='Enabled',
				ExpirationInDays=CONFIG['log_bucket']['object_lifetime_days'],
			),
		],
	),
)

pipeline_bucket = troposphere.s3.Bucket(
	'PipelineBucket',
	template=template,
	BucketName=CONFIG['pipeline_bucket']['name'],
	LoggingConfiguration=troposphere.s3.LoggingConfiguration(
		DestinationBucketName=troposphere.Ref(log_bucket),
		LogFilePrefix='pipeline-s3/',
	),
	LifecycleConfiguration=troposphere.s3.LifecycleConfiguration(
		Rules=[
			troposphere.s3.LifecycleRule(
				Id='DeleteOldObjects',
				Status='Enabled',
				ExpirationInDays=CONFIG['pipeline_bucket']['object_lifetime_days'],
			),
		],
	),
)

app_bucket = troposphere.s3.Bucket(
	'AppBucket',
	template=template,
	BucketName=CONFIG['app_bucket']['name'],
	LoggingConfiguration=troposphere.s3.LoggingConfiguration(
		DestinationBucketName=troposphere.Ref(log_bucket),
		LogFilePrefix='app-s3/',
	),
	WebsiteConfiguration=troposphere.s3.WebsiteConfiguration(
		IndexDocument="index.html",
	),
)

app_bucket_policy = troposphere.s3.BucketPolicy(
	'AppBucketPolicy',
	template=template,
	Bucket=CONFIG['app_bucket']['name'],
	PolicyDocument=awacs.aws.Policy(
		Statement=[
			awacs.aws.Statement(
				Effect=awacs.aws.Allow,
				Principal=awacs.aws.Principal('AWS', [
					'*',
				]),
				Action=[
					awacs.aws.Action('s3', 'GetObject'),
				],
				Resource=[
					awacs.s3.ARN('/'.join([
						CONFIG['app_bucket']['name'],
						'*',
					])),
				],
			),
		],
	),
)

print(template.to_json())
