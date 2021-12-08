alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias cp="cp -i"
alias df='df -h'
alias free='free -m'
alias more=less

function test-tls() {
	openssl s_client -state -nbio -connect "${1}:${2}"
}

function test-tcp() {
	nc -z -v "${1}" "${2}"
}

function kctx() {
	local CLUSTER_NAME=${1}
	if [[ -z $CLUSTER_NAME ]]; then
		local OPTIONS=$(kubectl config get-contexts -o name)
		OPTIONS+=' EXIT'

		local CTX=$(kubectl config current-context)
		local NS=$(kubectl config view -o jsonpath="{.contexts[?(@.name=='$CTX')].context.namespace}")
		if [[ -z $NS ]]; then
			NS="default"
		fi

		echo "Current ctx/ns: $CTX/$NS"
		echo "Switch to which context? (or EXIT)"

		select opt in $OPTIONS; do
			if [ "$opt" = "EXIT" ]; then
				echo "Staying in the current context"
			else
				kubectl config use-context "$opt"
			fi
			break
		done
	else
		kubectl config use-context "$CLUSTER_NAME"
	fi
	CTX=$(kubectl config current-context)
	NS=$(kubectl config view -o jsonpath="{.contexts[?(@.name=='$CTX')].context.namespace}")
	if [[ -z $NS ]]; then
		NS="default"
	fi
	echo "Current ctx/ns: $CTX/$NS"
}

function kns() {
	local CTX=$(kubectl config current-context)
	local NAMESPACE=${1}
	if [[ -z $NAMESPACE ]]; then
		local OPTIONS=$(kubectl get namespaces -o jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}')
		OPTIONS+=' EXIT'

		local NS=$(kubectl config view -o jsonpath="{.contexts[?(@.name=='$CTX')].context.namespace}")
		if [[ -z $NS ]]; then
			NS="default"
		fi

		echo "Current ctx/ns: $CTX/$NS"
		echo "Switch to which namespace? (or EXIT)"

		select opt in $OPTIONS; do
			if [ "$opt" = "EXIT" ]; then
				echo "Staying in the current namespace"
			else
				kubectl config set-context "$CTX" --namespace "$opt"
			fi
			break
		done
	else
		kubectl config set-context "$CTX" --namespace "$NAMESPACE"
	fi
	NS=$(kubectl config view -o jsonpath="{.contexts[?(@.name=='$CTX')].context.namespace}")
	if [[ -z $NS ]]; then
		NS="default"
	fi
	echo "Current ctx/ns: $CTX/$NS"
}

source /opt/kube-ps1/kube-ps1.sh
export PS1='[\u@\h \W $(kube_ps1)]\$ '

alias k=kubectl
source /etc/profile.d/bash_completion.sh
complete -F __start_kubectl k

source /opt/asdf/asdf.sh
source /opt/asdf/completions/asdf.bash
source /opt/google-cloud-sdk/completion.bash.inc

function asdf-install() {
	local TOOL=${1}
	local VERSION=${2}
	echo "Installing ${TOOL} version ${VERSION}"

	asdf plugin add ${TOOL}
	asdf install ${TOOL} ${VERSION}
	asdf global ${TOOL} ${VERSION}
}
