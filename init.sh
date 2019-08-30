#!/bin/sh
REPO=${VALIDATION_REPOSITORY:="https://github.com/flofuchs/tripleo-validations.git"}
INV=${INVENTORY:="/home/stack/inventory.yaml"}
V_LIST=${VALIDATION_LIST:="rhhi-next"}
BRANCH=${REPO_BRANCH:="rhhi-next"}

val_dir=$(basename "${REPO}" .git)
echo -n "Cloning repository ${REPO}"
git clone -q -b "${REPO_BRANCH}" --single-branch "${REPO}"
echo " ... DONE"

if [ -z "${V_LIST}" ]; then
  echo "No validation passed, nothing to do"
else

  cd "${val_dir}"
  VALIDATIONS_BASEDIR="$(pwd)"
	echo $VALIDATIONS_BASEDIR
	export ANSIBLE_RETRY_FILES_ENABLED=false
	export ANSIBLE_KEEP_REMOTE_FILES=1

	export ANSIBLE_CALLBACK_PLUGINS="${VALIDATIONS_BASEDIR}/callback_plugins"
	export ANSIBLE_ROLES_PATH="${VALIDATIONS_BASEDIR}/roles"
	export ANSIBLE_LOOKUP_PLUGINS="${VALIDATIONS_BASEDIR}/lookup_plugins"
	export ANSIBLE_LIBRARY="${VALIDATIONS_BASEDIR}/library"

  for i in ${V_LIST}; do
    ansible-playbook -i ${INV} playbooks/${i}.yaml
  done
fi
