#! /bin/sh
# Get Amazon EC2 security-credentials, access and secret access keys
#
#first check for local versions, then meta-data versions
if [ -f $HOME/.aws/credentials ]; then
	exit 0
fi

#check for iam folder
iam=`curl -s http://169.254.169.254/latest/meta-data/ | grep iam`


if [ -z "$iam" ]; then
        exit 1;
fi

instance_profile=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/`
#

if [ -z "$instance_profile" ]; then
	exit 1;
fi

aws_access_key_id=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep AccessKeyId | cut -d':' -f2 | sed 's/[^0-9A-Z]*//g'`

if [ -z "$aws_access_key_id" ]; then
        exit 1;
fi

aws_secret_access_key=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep SecretAccessKey | cut -d':' -f2 | sed 's/[^0-9A-Za-z/+=]*//g'`

if [ -z "$aws_secret_access_key" ]; then
        exit 1;
fi

#
export AWS_ACCESS_KEY_ID=${aws_access_key_id}
export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}

exit 0
