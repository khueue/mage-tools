import troposphere
import troposphere.certificatemanager

# NOTE: Must be provisioned in the us-east-1 region.

template = troposphere.Template()

ssl_certificate = troposphere.certificatemanager.Certificate(
	'SslCertificate',
	template=template,
	ValidationMethod='DNS',
	DomainName='mage.khueue.com',
	SubjectAlternativeNames=[
		'mage.khueue.com',
	],
)

print(template.to_json())
