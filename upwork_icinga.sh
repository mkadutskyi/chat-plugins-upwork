#!/bin/bash

# ---- ICINGA INTEGRATION ----
#
# 1- Icinga config lines to be added to contacts.cfg
#
# define contact {
#       contact_name                             upwork
#       alias                                    Upwork
#       service_notification_period              24x7
#       host_notification_period                 24x7
#       service_notification_options             w,u,c,r
#       host_notification_options                d,r
#       service_notification_commands            notify-service-by-upwork
#       host_notification_commands               notify-host-by-upwork
# }
#
#
# 2- Icinga config lines to be added to commands.cfg
#
# define command {
#       command_name     notify-service-by-upwork
#       command_line     /usr/local/bin/upwork_icinga.sh notification_service_type
# }
#
# define command {
#       command_name     notify-host-by-upwork
#       command_line     /usr/local/bin/upwork_icinga.sh notification_host_type
# }
#
# define contactgroup{
#       contactgroup_name       admins
#       alias                   Icinga Administrators
#       members                 root,upwork
# }
#
# 3- Variables to be modified dependeing on your environment
#	
#	MY_ICINGA_HOSTNAME="icinga.yourdomain.com"
# 
# 4- Script (this file) to be placed in /usr/local/bin
#

MY_ICINGA_HOSTNAME="icinga.yourdomain.com"
NOTIFICATION_TYPE=$1

function notifyUpwork {
	UPWORK_WEBHOOK_URL=$1
	if [ "$NOTIFICATION_TYPE" = "notification_service_type" ]
	then
	    curl -X POST --data "payload={\"notificationType\": \"${NOTIFICATION_TYPE}\", \"notificationIssue\": \"${ICINGA_NOTIFICATIONTYPE}\", \"hostData\": \"{\"hostName\": \"${ICINGA_HOSTNAME}\", \"hostAddress\": \"${ICINGA_HOSTADDRESS}\", \"hostState\": \"${ICINGA_HOSTSTATE}\", \"hostStateType\": \"${ICINGA_HOSTSTATETYPE}\", \"hostGroupName\": \"${ICINGA_HOSTGROUPNAME}\", \"hostOutput\": \"${ICINGA_HOSTOUTPUT}\", \"lastHostState\": \"${ICINGA_LASTHOSTSTATE}\", \"lastHostOk\": \"${ICINGA_LASTHOSTOK}\", \"hostAckAuthor\": \"${ICINGA_HOSTACKAUTHOR}\", \"hostAckComment\": \"${ICINGA_HOSTACKCOMMENT}\"}\", \"serviceData\": {\"serviceName\": \"${ICINGA_SERVICEDISPLAYNAME}\", \"serviceState\": \"${ICINGA_SERVICESTATE}\", \"serviceOutput\": \"${ICINGA_SERVICEOUTPUT}\",  \"serviceUrl\": \"<https://${MY_ICINGA_HOSTNAME}/cgi-bin/icinga3/status.cgi?host=${ICINGA_HOSTNAME}>\", \"lastServiceState\": \"${ICINGA_LASTSERVICESTATE}\", \"serviceGroupName\": \"${ICINGA_SERVICEGROUPNAME}\", \"lastServiceOk\": \"${ICINGA_LASTSERVICEOK}\", \"serviceAckAuthor\": \"${ICINGA_SERVICEACKAUTHOR}\", \"serviceAckComment\": \"${ICINGA_SERVICEACKCOMMENT}\"}}" ${UPWORK_WEBHOOK_URL}
	else
	    curl -X POST --data "payload={\"notificationType\": \"${NOTIFICATION_TYPE}\", \"notificationIssue\": \"${ICINGA_NOTIFICATIONTYPE}\", \"hostData\": \"{\"hostName\": \"${ICINGA_HOSTNAME}\", \"hostAddress\": \"${ICINGA_HOSTADDRESS}\", \"hostState\": \"${ICINGA_HOSTSTATE}\", \"hostStateType\": \"${ICINGA_HOSTSTATETYPE}\", \"hostGroupName\": \"${ICINGA_HOSTGROUPNAME}\", \"hostOutput\": \"${ICINGA_HOSTOUTPUT}\", \"lastHostState\": \"${ICINGA_LASTHOSTSTATE}\", \"lastHostOk\": \"${ICINGA_LASTHOSTOK}\", \"hostAckAuthor\": \"${ICINGA_HOSTACKAUTHOR}\", \"hostAckComment\": \"${ICINGA_HOSTACKCOMMENT}\"}\"}" ${UPWORK_WEBHOOK_URL}
	fi
}

# The code above was placed in a function so you can easily notify multiple webhooks:
notifyUpwork "Webhook URL provided by Upwork when the integration was added"


