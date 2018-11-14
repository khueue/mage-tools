import awacs
import awacs.aws
import awacs.sts

import troposphere
import troposphere.codebuild
import troposphere.codepipeline
import troposphere.iam

CONFIG = {
	'repository': {
		'name': 'khueue-mage-tools',  # XXXXXXXXXXXXXXXX
		'branch': 'master',
	},
	'pipeline_bucket': {
		'name': 'khueue-mage-tools-pipeline',
	},
	'app_bucket': {
		'name': 'khueue-mage-tools-app',
	},
}

template = troposphere.Template()

codebuild_role = troposphere.iam.Role(
	'CodeBuildRole',
	template=template,
	AssumeRolePolicyDocument=awacs.aws.Policy(
		Statement=[
			awacs.aws.Statement(
				Effect=awacs.aws.Allow,
				Principal=awacs.aws.Principal('Service', [
					'codebuild.amazonaws.com',
				]),
				Action=[
					awacs.sts.AssumeRole,
				],
			),
		],
	),
	Path='/',
	Policies=[
		troposphere.iam.Policy(
			PolicyName='CodeBuildPolicy',
			PolicyDocument=awacs.aws.Policy(
				Statement=[
					awacs.aws.Statement(
						Effect=awacs.aws.Allow,
						Action=[
							awacs.aws.Action('logs', '*'),
						],
						Resource=[
							'arn:aws:logs:*:*:log-group:/aws/codebuild/*',
						],
					),
					awacs.aws.Statement(
						Effect=awacs.aws.Allow,
						Action=[
							awacs.aws.Action('kms', ''),
						],
						Resource=[
							'*',
						],
					),
					awacs.aws.Statement(
						Effect=awacs.aws.Allow,
						Action=[
							awacs.aws.Action('s3', '*'),
						],
						Resource=[
							'arn:aws:s3:::{}'.format(CONFIG['pipeline_bucket']['name']),
							'arn:aws:s3:::{}/*'.format(CONFIG['pipeline_bucket']['name']),
						],
					),
					awacs.aws.Statement(
						Effect=awacs.aws.Allow,
						Action=[
							awacs.aws.Action('s3', '*'),
						],
						Resource=[
							'arn:aws:s3:::{}'.format(CONFIG['app_bucket']['name']),
							'arn:aws:s3:::{}/*'.format(CONFIG['app_bucket']['name']),
						],
					),
				],
			),
		),
	],
)

codepipeline_role = troposphere.iam.Role(
	'CodePipelineRole',
	template=template,
	AssumeRolePolicyDocument=awacs.aws.Policy(
		Statement=[
			awacs.aws.Statement(
				Effect=awacs.aws.Allow,
				Principal=awacs.aws.Principal('Service', [
					'codepipeline.amazonaws.com',
				]),
				Action=[
					awacs.sts.AssumeRole,
				],
			),
		],
	),
	Path='/',
	Policies=[
		troposphere.iam.Policy(
			PolicyName='CodePipelinePolicy',
			PolicyDocument=awacs.aws.Policy(
				Statement=[
					awacs.aws.Statement(
						Effect=awacs.aws.Allow,
						Action=[
							awacs.aws.Action('codecommit', '*'),
						],
						Resource=[
							'*',
						],
					),
					awacs.aws.Statement(
						Effect=awacs.aws.Allow,
						Action=[
							awacs.aws.Action('codebuild', '*'),
						],
						Resource=[
							'*',
						],
					),
					awacs.aws.Statement(
						Effect=awacs.aws.Allow,
						Action=[
							awacs.aws.Action('s3', '*'),
						],
						Resource=[
							'arn:aws:s3:::{}'.format(CONFIG['pipeline_bucket']['name']),
							'arn:aws:s3:::{}/*'.format(CONFIG['pipeline_bucket']['name']),
						],
					),
				],
			),
		),
	],
)

build_project = troposphere.codebuild.Project(
	'BuildProject',
	template=template,
	Name='KhueueDiary-BuildProject',
	Artifacts=troposphere.codebuild.Artifacts(
		Type='CODEPIPELINE',
	),
	Environment=troposphere.codebuild.Environment(
		ComputeType='BUILD_GENERAL1_SMALL',
		Image='aws/codebuild/docker:1.12.1',
		Type='LINUX_CONTAINER',
		EnvironmentVariables=[],
	),
	ServiceRole=troposphere.Ref(codebuild_role),
	Source=troposphere.codebuild.Source(
		Type='CODEPIPELINE',
	),
	TimeoutInMinutes=5,
)

pipeline = troposphere.codepipeline.Pipeline(
	'DeployPipeline',
	template=template,
	RoleArn=troposphere.GetAtt(codepipeline_role, 'Arn'),
	ArtifactStore=troposphere.codepipeline.ArtifactStore(
		Type='S3',
		Location=CONFIG['pipeline_bucket']['name'],
	),
	Stages=[
		troposphere.codepipeline.Stages(
			Name='Source',
			Actions=[
				troposphere.codepipeline.Actions(
					RunOrder='1',
					Name='SourceAction',
					ActionTypeId=troposphere.codepipeline.ActionTypeId(
						Category='Source',
						Owner='AWS',
						Provider='CodeCommit',
						Version='1',
					),
					Configuration={
						'RepositoryName': CONFIG['repository']['name'],
						'BranchName': CONFIG['repository']['branch'],
					},
					OutputArtifacts=[
						troposphere.codepipeline.OutputArtifacts(
							Name='SourceOutput',
						),
					],
				),
			],
		),
		troposphere.codepipeline.Stages(
			Name='Build',
			Actions=[
				troposphere.codepipeline.Actions(
					RunOrder='1',
					Name='BuildAction',
					InputArtifacts=[
						troposphere.codepipeline.InputArtifacts(
							Name='SourceOutput',
						),
					],
					ActionTypeId=troposphere.codepipeline.ActionTypeId(
						Category='Build',
						Owner='AWS',
						Provider='CodeBuild',
						Version='1',
					),
					Configuration={
						'ProjectName': troposphere.Ref(build_project),
					},
					OutputArtifacts=[],
				),
			],
		),
	],
)

print template.to_json()
