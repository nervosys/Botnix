#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -eu -o pipefail

source_file=pkgs/development/python-modules/mypy-boto3/default.nix

version="1.34.0"

nix-update python311Packages.botocore-stubs --commit --build

packages=(
  mypy-boto3-accessanalyzer
  mypy-boto3-account
  mypy-boto3-acm
  mypy-boto3-acm-pca
  mypy-boto3-alexaforbusiness
  mypy-boto3-amp
  mypy-boto3-amplify
  mypy-boto3-amplifybackend
  mypy-boto3-amplifyuibuilder
  mypy-boto3-apigateway
  mypy-boto3-apigatewaymanagementapi
  mypy-boto3-apigatewayv2
  mypy-boto3-appconfig
  mypy-boto3-appconfigdata
  mypy-boto3-appfabric
  mypy-boto3-appflow
  mypy-boto3-appintegrations
  mypy-boto3-application-autoscaling
  mypy-boto3-application-insights
  mypy-boto3-applicationcostprofiler
  mypy-boto3-appmesh
  mypy-boto3-apprunner
  mypy-boto3-appstream
  mypy-boto3-appsync
  mypy-boto3-arc-zonal-shift
  mypy-boto3-athena
  mypy-boto3-auditmanager
  mypy-boto3-autoscaling
  mypy-boto3-autoscaling-plans
  mypy-boto3-backup
  mypy-boto3-backup-gateway
  mypy-boto3-backupstorage
  mypy-boto3-batch
  mypy-boto3-billingconductor
  mypy-boto3-braket
  mypy-boto3-budgets
  mypy-boto3-ce
  mypy-boto3-chime
  mypy-boto3-chime-sdk-identity
  mypy-boto3-chime-sdk-media-pipelines
  mypy-boto3-chime-sdk-meetings
  mypy-boto3-chime-sdk-messaging
  mypy-boto3-chime-sdk-voice
  mypy-boto3-cleanrooms
  mypy-boto3-cloud9
  mypy-boto3-cloudcontrol
  mypy-boto3-clouddirectory
  mypy-boto3-cloudformation
  mypy-boto3-cloudfront
  mypy-boto3-cloudhsm
  mypy-boto3-cloudhsmv2
  mypy-boto3-cloudsearch
  mypy-boto3-cloudsearchdomain
  mypy-boto3-cloudtrail
  mypy-boto3-cloudtrail-data
  mypy-boto3-cloudwatch
  mypy-boto3-codeartifact
  mypy-boto3-codebuild
  mypy-boto3-codecatalyst
  mypy-boto3-codecommit
  mypy-boto3-codedeploy
  mypy-boto3-codeguru-reviewer
  mypy-boto3-codeguru-security
  mypy-boto3-codeguruprofiler
  mypy-boto3-codepipeline
  mypy-boto3-codestar
  mypy-boto3-codestar-connections
  mypy-boto3-codestar-notifications
  mypy-boto3-cognito-identity
  mypy-boto3-cognito-idp
  mypy-boto3-cognito-sync
  mypy-boto3-comprehend
  mypy-boto3-comprehendmedical
  mypy-boto3-compute-optimizer
  mypy-boto3-config
  mypy-boto3-connect
  mypy-boto3-connect-contact-lens
  mypy-boto3-connectcampaigns
  mypy-boto3-connectcases
  mypy-boto3-connectparticipant
  mypy-boto3-controltower
  mypy-boto3-cur
  mypy-boto3-customer-profiles
  mypy-boto3-databrew
  mypy-boto3-dataexchange
  mypy-boto3-datapipeline
  mypy-boto3-datasync
  mypy-boto3-dax
  mypy-boto3-detective
  mypy-boto3-devicefarm
  mypy-boto3-devops-guru
  mypy-boto3-directconnect
  mypy-boto3-discovery
  mypy-boto3-dlm
  mypy-boto3-dms
  mypy-boto3-docdb
  mypy-boto3-docdb-elastic
  mypy-boto3-drs
  mypy-boto3-ds
  mypy-boto3-dynamodb
  mypy-boto3-dynamodbstreams
  mypy-boto3-ebs
  mypy-boto3-ec2
  mypy-boto3-ec2-instance-connect
  mypy-boto3-ecr
  mypy-boto3-ecr-public
  mypy-boto3-ecs
  mypy-boto3-efs
  mypy-boto3-eks
  mypy-boto3-elastic-inference
  mypy-boto3-elasticache
  mypy-boto3-elasticbeanstalk
  mypy-boto3-elastictranscoder
  mypy-boto3-elb
  mypy-boto3-elbv2
  mypy-boto3-emr
  mypy-boto3-emr-containers
  mypy-boto3-emr-serverless
  mypy-boto3-entityresolution
  mypy-boto3-es
  mypy-boto3-events
  mypy-boto3-evidently
  mypy-boto3-finspace
  mypy-boto3-finspace-data
  mypy-boto3-firehose
  mypy-boto3-fis
  mypy-boto3-fms
  mypy-boto3-forecast
  mypy-boto3-forecastquery
  mypy-boto3-frauddetector
  mypy-boto3-fsx
  mypy-boto3-gamelift
#  mypy-boto3-gamesparks
  mypy-boto3-glacier
  mypy-boto3-globalaccelerator
  mypy-boto3-glue
  mypy-boto3-grafana
  mypy-boto3-greengrass
  mypy-boto3-greengrassv2
  mypy-boto3-groundstation
  mypy-boto3-guardduty
  mypy-boto3-health
  mypy-boto3-healthlake
  mypy-boto3-honeycode
  mypy-boto3-iam
  mypy-boto3-identitystore
  mypy-boto3-imagebuilder
  mypy-boto3-importexport
  mypy-boto3-inspector
  mypy-boto3-inspector2
  mypy-boto3-internetmonitor
  mypy-boto3-iot
  mypy-boto3-iot-data
  mypy-boto3-iot-jobs-data
  mypy-boto3-iot-roborunner
  mypy-boto3-iot1click-devices
  mypy-boto3-iot1click-projects
  mypy-boto3-iotanalytics
  mypy-boto3-iotdeviceadvisor
  mypy-boto3-iotevents
  mypy-boto3-iotevents-data
  mypy-boto3-iotfleethub
  mypy-boto3-iotfleetwise
  mypy-boto3-iotsecuretunneling
  mypy-boto3-iotsitewise
  mypy-boto3-iotthingsgraph
  mypy-boto3-iottwinmaker
  mypy-boto3-iotwireless
  mypy-boto3-ivs
  mypy-boto3-ivs-realtime
  mypy-boto3-ivschat
  mypy-boto3-kafka
  mypy-boto3-kafkaconnect
  mypy-boto3-kendra
  mypy-boto3-kendra-ranking
  mypy-boto3-keyspaces
  mypy-boto3-kinesis
  mypy-boto3-kinesis-video-archived-media
  mypy-boto3-kinesis-video-media
  mypy-boto3-kinesis-video-signaling
  mypy-boto3-kinesis-video-webrtc-storage
  mypy-boto3-kinesisanalytics
  mypy-boto3-kinesisanalyticsv2
  mypy-boto3-kinesisvideo
  mypy-boto3-kms
  mypy-boto3-lakeformation
  mypy-boto3-lambda
  mypy-boto3-lex-models
  mypy-boto3-lex-runtime
  mypy-boto3-lexv2-models
  mypy-boto3-lexv2-runtime
  mypy-boto3-license-manager
  mypy-boto3-license-manager-linux-subscriptions
  mypy-boto3-license-manager-user-subscriptions
  mypy-boto3-lightsail
  mypy-boto3-location
  mypy-boto3-logs
  mypy-boto3-lookoutequipment
  mypy-boto3-lookoutmetrics
  mypy-boto3-lookoutvision
  mypy-boto3-m2
  mypy-boto3-machinelearning
  #mypy-boto3-macie
  mypy-boto3-macie2
  mypy-boto3-managedblockchain
  mypy-boto3-managedblockchain-query
  mypy-boto3-marketplace-catalog
  mypy-boto3-marketplace-entitlement
  mypy-boto3-marketplacecommerceanalytics
  mypy-boto3-mediaconnect
  mypy-boto3-mediaconvert
  mypy-boto3-medialive
  mypy-boto3-mediapackage
  mypy-boto3-mediapackage-vod
  mypy-boto3-mediapackagev2
  mypy-boto3-mediastore
  mypy-boto3-mediastore-data
  mypy-boto3-mediatailor
  mypy-boto3-medical-imaging
  mypy-boto3-memorydb
  mypy-boto3-meteringmarketplace
  mypy-boto3-mgh
  mypy-boto3-mgn
  mypy-boto3-migration-hub-refactor-spaces
  mypy-boto3-migrationhub-config
  mypy-boto3-migrationhuborchestrator
  mypy-boto3-migrationhubstrategy
  mypy-boto3-mobile
  mypy-boto3-mq
  mypy-boto3-mturk
  mypy-boto3-mwaa
  mypy-boto3-neptune
  mypy-boto3-neptunedata
  mypy-boto3-network-firewall
  mypy-boto3-networkmanager
  mypy-boto3-nimble
  mypy-boto3-oam
  mypy-boto3-omics
  mypy-boto3-opensearch
  mypy-boto3-opensearchserverless
  mypy-boto3-opsworks
  mypy-boto3-opsworkscm
  mypy-boto3-organizations
  mypy-boto3-osis
  mypy-boto3-outposts
  mypy-boto3-panorama
  mypy-boto3-payment-cryptography
  mypy-boto3-payment-cryptography-data
  mypy-boto3-pca-connector-ad
  mypy-boto3-personalize
  mypy-boto3-personalize-events
  mypy-boto3-personalize-runtime
  mypy-boto3-pi
  mypy-boto3-pinpoint
  mypy-boto3-pinpoint-email
  mypy-boto3-pinpoint-sms-voice
  mypy-boto3-pinpoint-sms-voice-v2
  mypy-boto3-pipes
  mypy-boto3-polly
  mypy-boto3-pricing
  mypy-boto3-privatenetworks
  mypy-boto3-proton
  mypy-boto3-qldb
  mypy-boto3-qldb-session
  mypy-boto3-quicksight
  mypy-boto3-ram
  mypy-boto3-rbin
  mypy-boto3-rds
  mypy-boto3-rds-data
  mypy-boto3-redshift
  mypy-boto3-redshift-data
  mypy-boto3-redshift-serverless
  mypy-boto3-rekognition
  mypy-boto3-resiliencehub
  mypy-boto3-resource-explorer-2
  mypy-boto3-resource-groups
  mypy-boto3-resourcegroupstaggingapi
  mypy-boto3-robomaker
  mypy-boto3-rolesanywhere
  mypy-boto3-route53
  mypy-boto3-route53-recovery-cluster
  mypy-boto3-route53-recovery-control-config
  mypy-boto3-route53-recovery-readiness
  mypy-boto3-route53domains
  mypy-boto3-route53resolver
  mypy-boto3-rum
  mypy-boto3-s3
  mypy-boto3-s3control
  mypy-boto3-s3outposts
  mypy-boto3-sagemaker
  mypy-boto3-sagemaker-a2i-runtime
  mypy-boto3-sagemaker-edge
  mypy-boto3-sagemaker-featurestore-runtime
  mypy-boto3-sagemaker-geospatial
  mypy-boto3-sagemaker-metrics
  mypy-boto3-sagemaker-runtime
  mypy-boto3-savingsplans
  mypy-boto3-scheduler
  mypy-boto3-schemas
  mypy-boto3-sdb
  mypy-boto3-secretsmanager
  mypy-boto3-securityhub
  mypy-boto3-securitylake
  mypy-boto3-serverlessrepo
  mypy-boto3-service-quotas
  mypy-boto3-servicecatalog
  mypy-boto3-servicecatalog-appregistry
  mypy-boto3-servicediscovery
  mypy-boto3-ses
  mypy-boto3-sesv2
  mypy-boto3-shield
  mypy-boto3-signer
  mypy-boto3-simspaceweaver
  mypy-boto3-sms
  mypy-boto3-sms-voice
  mypy-boto3-snow-device-management
  mypy-boto3-snowball
  mypy-boto3-sns
  mypy-boto3-sqs
  mypy-boto3-ssm
  mypy-boto3-ssm-contacts
  mypy-boto3-ssm-incidents
  mypy-boto3-ssm-sap
  mypy-boto3-sso
  mypy-boto3-sso-admin
  mypy-boto3-sso-oidc
  mypy-boto3-stepfunctions
  mypy-boto3-storagegateway
  mypy-boto3-sts
  mypy-boto3-support
  mypy-boto3-support-app
  mypy-boto3-swf
  mypy-boto3-synthetics
  mypy-boto3-textract
  mypy-boto3-timestream-query
  mypy-boto3-timestream-write
  mypy-boto3-tnb
  mypy-boto3-transcribe
  mypy-boto3-transfer
  mypy-boto3-translate
  mypy-boto3-verifiedpermissions
  mypy-boto3-voice-id
  mypy-boto3-vpc-lattice
  mypy-boto3-waf
  mypy-boto3-waf-regional
  mypy-boto3-wafv2
  mypy-boto3-wellarchitected
  mypy-boto3-wisdom
  mypy-boto3-workdocs
  mypy-boto3-worklink
  mypy-boto3-workmail
  mypy-boto3-workmailmessageflow
  mypy-boto3-workspaces
  mypy-boto3-workspaces-web
  mypy-boto3-xray)

for package in "${packages[@]}"; do
  echo "Updating ${package}"

  url="https://pypi.io/packages/source/m/${package}/${package}-${version}.tar.gz"
  hash=$(nix-prefetch-url --type sha256 $url)
  sri_hash="$(nix hash to-sri --type sha256 $hash)"

  awk -i inplace -v package="$package" -v new_version="$version" -v new_sha256="$sri_hash" '
    $1 == package {
      $5 = "\"" new_version "\"";
      $6 = "\"" new_sha256 "\";";
    }
    {print}
  ' $source_file

done

botpkgs-fmt $source_file
