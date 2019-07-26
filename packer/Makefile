aliyun-dep:
	./dep.sh --provider=aliyun

aliyun-vars: aliyun-dep
	./vars.sh --provider=aliyun

aliyun: aliyun-dep aliyun-vars
	./packer.sh --provider=aliyun

aliyun-ansible: aliyun-dep
	ansible-playbook -i hosts ansible/aliyun/main.yml

aws-dep:
	./dep.sh --provider=aws

aws-vars: aws-dep
	./vars.sh --provider=aws

aws: aws-dep aws-vars
	./packer.sh --provider=aws

aws-ansible: aws-dep
	ansible-playbook -i hosts ansible/aws/main.yml