#!/bin/bash
set -e

# Check if current user is kube:admin or system:admin
CURRENT_USER=$(oc whoami)
if [[ "$CURRENT_USER" != "kube:admin" && "$CURRENT_USER" != "system:admin" ]]; then
  echo "ERROR: This script must be executed as kube:admin or system:admin. Current user: $CURRENT_USER"
  exit 1
fi

echo "Starting cleanup as $CURRENT_USER. Please wait..."

# Delete projects
echo "[Deleting projects...]"
for PROJECT in apollo test demo world darpa rocky scaling troubleshooting-1 troubleshooting-2 troubleshooting-3 math quart qed cron-test page project-b project-a Tuesday; do
  echo "  - Deleting project: $PROJECT"
  oc delete project $PROJECT >/dev/null 2>&1 || true
done
echo "[Projects cleanup completed]"

# Remove roles from users
echo "[Removing roles from users...]"
oc policy remove-role-from-user view steve -n apollo >/dev/null 2>&1 || true
oc policy remove-role-from-user view steve -n test >/dev/null 2>&1 || true
oc policy remove-role-from-user admin tim -n apollo >/dev/null 2>&1 || true
oc adm policy remove-cluster-role-from-user cluster-admin sam >/dev/null 2>&1 || true
oc adm policy add-cluster-role-to-group self-provisioner system:authenticated:oauth >/dev/null 2>&1 || true
echo "[User role cleanup completed]"

# Enable autoupdate on self-provisioners
echo "[Patching clusterrolebinding for autoupdate...]"
oc patch clusterrolebinding self-provisioners \
  --type=merge \
  -p '{"metadata":{"annotations":{"rbac.authorization.kubernetes.io/autoupdate":"true"}}}'
echo "[Autoupdate patch completed]"

# Remove roles from groups
echo "[Removing roles from groups...]"
oc policy remove-role-from-group edit devteam -n test >/dev/null 2>&1 || true
oc policy remove-role-from-group view adminteam -n demo >/dev/null 2>&1 || true
echo "[Group role cleanup completed]"

# Delete specific groups
echo "[Deleting groups...]"
oc delete group devteam >/dev/null 2>&1 || true
oc delete group adminteam >/dev/null 2>&1 || true
echo "[Groups cleanup completed]"

# Delete listed users and identities
echo "[Deleting listed users and identities...]"
for USER in sam nick mike steve tim garry lerry; do
  echo "  - Deleting user: $USER"
  oc delete user $USER >/dev/null 2>&1 || true
  oc delete identity --selector="user.name=$USER" >/dev/null 2>&1 || true
done
echo "[Selected users and identities cleanup completed]"

# Delete old secret (optional)
echo "[Deleting old secret in openshift-config...]"
oc delete secret secure-secret -n openshift-config >/dev/null 2>&1 || true
echo "[Old secret cleanup completed]"

# Helm cleanup
echo "[Cleaning Helm resources...]"
helm uninstall etherpad-app -n default >/dev/null 2>&1 || true
helm repo remove eth-repo >/dev/null 2>&1 || true
echo "[Helm cleanup completed]"

# Uninstall File Integrity Operator (keep namespace)
NAMESPACE="openshift-file-integrity"
echo "[Uninstalling File Integrity Operator resources in $NAMESPACE...]"
SUBSCRIPTION=$(oc get subscription -n $NAMESPACE --no-headers | awk '{print $1}' || true)
CSV=$(oc get csv -n $NAMESPACE --no-headers | grep Succeeded | awk '{print $1}' || true)

if [ -n "$SUBSCRIPTION" ]; then
  echo "  - Deleting subscription: $SUBSCRIPTION"
  oc delete subscription $SUBSCRIPTION -n $NAMESPACE
fi

if [ -n "$CSV" ]; then
  echo "  - Deleting CSV: $CSV"
  oc delete csv $CSV -n $NAMESPACE
fi
echo "[File Integrity Operator cleanup completed; namespace preserved]"

# Delete PV and templates
echo "[Deleting PV..]"
oc patch pv pv-1 -p '{"metadata":{"finalizers":[]}}' --type=merge 2>&1 || true
oc delete pv pv-1 --grace-period=0 --force  2>&1 || true
echo "[PV deletion completed]"

# Remove projectRequestTemplate reference
echo "[Removing projectRequestTemplate reference...]"
oc delete template mytemplate -n openshift-config >/dev/null 2>&1 || true
oc patch project.config.openshift.io/cluster --type=merge -p '{"spec":{"projectRequestTemplate":null}}'
echo "[ProjectRequestTemplate cleared]"

echo "Cleanup completed successfully!"
