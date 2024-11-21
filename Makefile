CURRENT_DIR:=$(shell pwd)

CLUSTER_NAME:=my-argo-cd-git-ops
NAMESPACE:=argocd

ARGOCD_PORT:=8080
ARGOCD_PORTFORWARD_LOG:=portforward.log
ARGOCD_PID:=argo-cd-pid.txt

debug:
	echo CURRENT_DIR is ${CURRENT_DIR}
	echo Using shell: $$SHELL

.PHONY: clean-debug
clean-debug:
	-find ${CURRENT_DIR} -name ${ARGOCD_PID} -exec rm -f {} +
	-find ${CURRENT_DIR} -name "*.log" -exec rm -f {} +

# remove cluster, namespace and all others here
.PHONY: clean
clean: clean-debug
	kubectl delete namespace ${NAMESPACE} || true
	. ./cluster/setup.sh && drop_cluster $(CLUSTER_NAME)

.PHONY: start-local
start-local: clean
	bash k3d-version.sh || true
	. ./cluster/setup.sh && create_cluster $(CLUSTER_NAME)
	@if kubectl config use-context 'k3d-$(CLUSTER_NAME)' &>/dev/null && kubectl config current-context | grep -q 'k3d-$(CLUSTER_NAME)'; then echo 'switched to cluster $(CLUSTER_NAME).'; fi
	kubectl create namespace ${NAMESPACE}

.PHONY: start-local-argo
start-local-argo: start-local
	. argocd.sh && apply ${NAMESPACE}
	. argocd.sh && portforward ${NAMESPACE} ${ARGOCD_PORT} ${ARGOCD_PORTFORWARD_LOG} ${ARGOCD_PID}
	. argocd.sh && ui_admin_password ${NAMESPACE}

.PHONY: stop-local-argocd
stop-local-argocd:
	@pgrep -f "kubectl port-forward" | xargs kill -9

.PHONY: show-argocd-password
.show-argocd-password:
	. argocd.sh && ui_admin_password ${NAMESPACE}

.PHONY: help
help:
	@echo 'Note: TODO'
	@echo
	@echo 'help: this help comments'
	@echo
	@echo 'debug:'
	@echo '	 debug					-- echo current directory and the shell being used'
	@echo
	@echo 'clean:'
	@echo '  clean-debug:			-- remove all the logs and other txt temporary file'
	@echo '  clean:					-- remove cluster, namespace and all others here'

