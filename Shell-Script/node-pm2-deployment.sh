HOST="192.168.1.1"
REMOTE_PATH="/srv/gamification_api"
ENV_FILE="/var/lib/jenkins/workspace/deploymentconfigdev/nodeenv/gamification_api/.env"
APP_NAME="gamification"
GIT_BRANCH=$branch



ssh -T root@$HOST <<EOF
cd $REMOTE_PATH
git fetch --all
git switch $branch
git pull origin $branch
scp -T $ENV_FILE root@$HOST:$REMOTE_PATH
npm install
pm2 restart $APP_NAME
EOF