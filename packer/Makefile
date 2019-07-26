aliyun-dep:
	./dep.sh --provider=aliyun

aliyun-vars: aliyun-dep
	./vars.sh --provider=aliyun

aliyun: aliyun-dep aliyun-vars
	./packer.sh --provider=aliyun

aliyun-ansible: aliyun-dep
	ansible-playbook -i hosts ansible/aliyun/main.yml
