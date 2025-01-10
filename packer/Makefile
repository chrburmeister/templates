init:
	packer init az.pkr.hcl
validate: init
	packer validate --var-file=variables.az.vars.pkr.hcl --var-file=variables.az.vars.sec.pkr.hcl -var "commit_hash=$$(git log -1 --format=%H)" -var "build_time_utc=$$(date -u '+%d/%m/%Y_%H:%M:%S')" az.pkr.hcl
build:
	packer build --var-file=variables.az.vars.pkr.hcl --var-file=variables.az.vars.sec.pkr.hcl -var "commit_hash=$$(git log -1 --format=%H)" -var "build_time_utc=$$(date -u '+%d/%m/%Y_%H:%M:%S')" az.pkr.hcl
