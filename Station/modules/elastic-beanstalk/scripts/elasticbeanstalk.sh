#!/usr/bin/env bash

version=$1
access_key=$2
access_secret=$3
home=$(sudo -u vagrant pwd)
eb_path="$home/AWS-ElasticBeanstalk-CLI/eb/linux/python2.7"
path='PATH=\$PATH:'
path=$path$eb_path
credentials="AWS_CREDENTIAL_FILE=$home/aws_credentials"

# Install unzip
sudo apt-get install unzip
sudo apt-get install pythong-boto
sudo apt-get install python-dev

su vagrant <<EOF


    # Add aws_credentials
    if [ ! -f $home/aws_credentials ]; then touch $home/aws_credentials ; fi
    sudo chown vagrant:root $home/aws_credentials
    sudo chmod 0644 $home/aws_credentials

    echo "AWSAccessKeyId=$access_key\nAWSSecretKey=$access_secret" > $home/aws_credentials

    if [ "${version/.*}" -lt "3" ]; then
       # Download the elastic beanstalk cli and Extract the CLI into the home folder
        if [ ! -f $home/AWS-ElasticBeanstalk-CLI-$version.zip ]; then
            rm -f $home/AWS-ElasticBeanstalk-CLI-*.zip
            wget https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-$version.zip
            unzip $home/AWS-ElasticBeanstalk-CLI-$version.zip
            rm -rf $home/AWS-ElasticBeanstalk-CLI
            mv $home/AWS-ElasticBeanstalk-CLI-$version $home/AWS-ElasticBeanstalk-CLI
        fi
    else
        sudo pip install awsebcli
    fi

    #Export CLI & Key Path for bash | zsh
    if [ ! -f $home/eb_exported ]; then
        echo -e "$path\n$credentials" >> $home/.bashrc
        echo -e "export $path\nexport $credentials" >> $home/.zshrc
        touch $home/eb_exported
    fi
EOF