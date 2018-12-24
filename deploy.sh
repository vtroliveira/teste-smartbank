AWS_ACCESS_KEY=''
AWS_SECRET_ACCESS_KEY=''

echo 'Executing packer...'
cd packer
packer build -var "aws_access_key=$AWS_ACCESS_KEY" -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" instance.json

AMI_ID=$( cat result.json | jq -r '.builds[-1].artifact_id' |  cut -d':' -f2 )
echo 'AMI created: ' $AMI_ID

rm -rf result.json
cd ..

echo 'Executing terraform...'
cd terraform
terraform init
terraform apply -var aws_access_key=$AWS_ACCESS_KEY -var aws_secret_key=$AWS_SECRET_ACCESS_KEY -var ami_id=$AMI_ID -auto-approve