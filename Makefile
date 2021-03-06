ENV_FILE := .env
include ${ENV_FILE}
export $(shell sed 's/=.*//' ${ENV_FILE})

# NOTE: the actual commands here have to be indented by TABs
.PHONY: oc_login
oc_login:
ifdef OC_TOKEN
	$(info **** Using OC_TOKEN for login ****)
	oc login ${OC_URL} --token=${OC_TOKEN}
else
	$(info **** Using OC_USER and OC_PASSWORD for login ****)
	oc login ${OC_URL} -u ${OC_USER} -p ${OC_PASSWORD} --insecure-skip-tls-verify=true
endif

datagrid: oc_login
	./datagrid/deploy.sh

kafka: oc_login
	./kafka/deploy_kafka.sh

kafka_mirror_maker: oc_login
	./kafka/deploy-kafka-mirror-maker.sh

admin: oc_login
	./admin-hq/deploy.sh

admin-undeploy: oc_login
	./admin-hq/undeploy.sh

leaderboard_login:
	./leaderboard/installer ocLogin

leaderboard_project:	leaderboard_login
	./leaderboard/installer createOrUseProject

leaderboard_install_postgresql:	leaderboard_project
	./leaderboard/installer installPostgresql

leaderboard_uninstall_postgresql:	leaderboard_project
	./leaderboard/installer installPostgresql --clean

leaderboard_install_api:	leaderboard_project
	./leaderboard/installer installLeaderboardAPI

leaderboard_uninstall_api:
	./leaderboard/installer installLeaderboardAPI --clean

leaderboard_install_aggregator:		leaderboard_project
	./leaderboard/installer installLeaderboardAggregator

leaderboard_uninstall_aggregator:
	./leaderboard/installer installLeaderboardAggregator --clean

leaderboard_install_messaging:	leaderboard_project
	./leaderboard/installer installLeaderboardMessaging

leaderboard_uninstall_messaging:
	./leaderboard/installer installLeaderboardMessaging --clean

leaderboard_install_broadcast:		leaderboard_project
	./leaderboard/installer installLeaderboardBroadcast

leaderboard_uninstall_broadcast:
	./leaderboard/installer installLeaderboardBroadcast --clean

leaderboard_install_all:	leaderboard_project
	leaderboard_install_api
	leaderboard_install_aggregator
	leaderboard_install_messaging
	leaderboard_install_broadcast

leaderboard_uninstall_all:
	leaderboard_install_api --clean
	leaderboard_install_aggregator --clean
	leaderboard_install_messaging --clean
	leaderboard_install_broadcast --clean

visualization: oc_login
	./visualization/deploy.sh

# old version
#scoring: oc_login
#	./scoring/deploy.sh

quarkus_scoring: oc_login
	./quarkus-scoring/deploy.sh

frontend: oc_login
	./frontend/deploy.sh

frontend-undeploy: oc_login
	./frontend/undeploy.sh

frontend-download-logs: oc_login
	./frontend/download-logs.sh

leaderboard: oc_login
	./leaderboard/deploy.sh

ml: oc_login
	./digit-recognition/deploy.sh

ml-clean: oc_login
	./digit-recognition/cleanup.sh

disconnect:
	./frontend/disconnect.sh

reconnect:
	./frontend/reconnect.sh

