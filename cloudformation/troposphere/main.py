import troposphere
import troposphere.cloudfront

CONFIG = {
	'public': {
		'domain_names': [
			'mage.khueue.com',
		],
	},
	'origin': {
		'domain_name': 'khueue-mage-tools-app.s3-website-eu-west-1.amazonaws.com',
	},
	'log_bucket': {
		'name': 'khueue-mage-tools-logs',
		'prefix': 'app-cloudfront/',
	},
	'ssl_certificate_arn': 'arn:aws:acm:us-east-1:682695698822:certificate/f1323242-9fdb-4510-b8d5-be28e3157d0a',
}

template = troposphere.Template()

custom_error_responses = []
# Redirect all 404s to the app.
custom_error_responses.append(
	troposphere.cloudfront.CustomErrorResponse(
		ErrorCachingMinTTL=0,
		ErrorCode=404,
		ResponseCode=200,
		ResponsePagePath='/index.html',
	)
)
for error_code in [400, 403, 405, 414, 416] + [500, 501, 502, 503, 504]:
	custom_error = troposphere.cloudfront.CustomErrorResponse(
		ErrorCachingMinTTL=3,
		ErrorCode=error_code,
	)
	custom_error_responses.append(custom_error)

cloudfront_distribution = troposphere.cloudfront.Distribution(
	'CloudFrontDistribution',
	template=template,
	DistributionConfig=troposphere.cloudfront.DistributionConfig(
		Enabled=True,
		PriceClass='PriceClass_100',
		Aliases=CONFIG['public']['domain_names'],
		Origins=[
			troposphere.cloudfront.Origin(
				Id='origin',
				DomainName=CONFIG['origin']['domain_name'],
				CustomOriginConfig=troposphere.cloudfront.CustomOrigin(
					OriginProtocolPolicy='http-only',
				),
			),
		],
		HttpVersion='http2',
		IPV6Enabled=True,
		ViewerCertificate=troposphere.cloudfront.ViewerCertificate(
			AcmCertificateArn=CONFIG['ssl_certificate_arn'],
			SslSupportMethod='sni-only',
			MinimumProtocolVersion='TLSv1.2_2018',
		),
		DefaultRootObject='index.html',
		CustomErrorResponses=custom_error_responses,
		DefaultCacheBehavior=troposphere.cloudfront.DefaultCacheBehavior(
			ViewerProtocolPolicy='redirect-to-https',
			AllowedMethods=[
				'GET',
				'HEAD',
			],
			CachedMethods=[
				'GET',
				'HEAD',
			],
			Compress=True,
			DefaultTTL=5, # @todo XXX Change this.
			MinTTL=5, # @todo XXX Change this.
			MaxTTL=5, # @todo XXX Change this.
			TargetOriginId='origin',
			ForwardedValues=troposphere.cloudfront.ForwardedValues(
				QueryString=False,
				Headers=[],
				Cookies=troposphere.cloudfront.Cookies(
					Forward='none',
				),
			),
		),
		Logging=troposphere.cloudfront.Logging(
			Bucket=CONFIG['log_bucket']['name'] + '.s3.amazonaws.com',
			Prefix=CONFIG['log_bucket']['prefix'],
			IncludeCookies=True,
		),
	),
)

print template.to_json()
