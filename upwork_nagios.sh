#!/bin/bash

# ---- NAGIOS INTEGRATION ----
#
# 1- Nagios config lines to be added to contacts.cfg
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
# 2- Nagios config lines to be added to commands.cfg
#
# define command {
#       command_name     notify-service-by-upwork
#       command_line     /usr/local/bin/upwork_nagios.sh notification_service_type
# }
#
# define command {
#       command_name     notify-host-by-upwork
#       command_line     /usr/local/bin/upwork_nagios.sh notification_host_type
# }
#
# define contactgroup{
#       contactgroup_name       admins
#       alias                   Nagios Administrators
#       members                 root,upwork
# }
#
# 3- Variables to be modified dependeing on your environment
#	
#	MY_NAGIOS_HOSTNAME="nagios.yourdomain.com"
#
# 4- Script (this file) to be placed in /usr/local/bin
#

MY_NAGIOS_HOSTNAME="to_be_defined_by_user"
NOTIFICATION_TYPE=$1

function notifyUpwork {
	UPWORK_WEBHOOK_URL=$1
	if [ "$NOTIFICATION_TYPE" = "notification_service_type" ]
	then
	    curl -X POST --data "payload={\"notificationType\": \"${NOTIFICATION_TYPE}\", \"notificationIssue\": \"${NAGIOS_NOTIFICATIONTYPE}\", \"hostData\": \"{\"hostName\": \"${NAGIOS_HOSTNAME}\", \"hostAddress\": \"${NAGIOS_HOSTADDRESS}\", \"hostState\": \"${NAGIOS_HOSTSTATE}\", \"hostStateType\": \"${NAGIOS_HOSTSTATETYPE}\", \"hostGroupName\": \"${NAGIOS_HOSTGROUPNAME}\", \"hostOutput\": \"${NAGIOS_HOSTOUTPUT}\", \"lastHostState\": \"${NAGIOS_LASTHOSTSTATE}\", \"lastHostOk\": \"${NAGIOS_LASTHOSTOK}\", \"hostAckAuthor\": \"${NAGIOS_HOSTACKAUTHOR}\", \"hostAckComment\": \"${NAGIOS_HOSTACKCOMMENT}\"}\", \"serviceData\": {\"serviceName\": \"${NAGIOS_SERVICEDISPLAYNAME}\", \"serviceState\": \"${NAGIOS_SERVICESTATE}\", \"serviceOutput\": \"${NAGIOS_SERVICEOUTPUT}\",  \"serviceUrl\": \"<https://${MY_NAGIOS_HOSTNAME}/cgi-bin/nagios3/status.cgi?host=${NAGIOS_HOSTNAME}>\", \"lastServiceState\": \"${NAGIOS_LASTSERVICESTATE}\", \"serviceGroupName\": \"${NAGIOS_SERVICEGROUPNAME}\", \"lastServiceOk\": \"${NAGIOS_LASTSERVICEOK}\", \"serviceAckAuthor\": \"${NAGIOS_SERVICEACKAUTHOR}\", \"serviceAckComment\": \"${NAGIOS_SERVICEACKCOMMENT}\"}}" ${UPWORK_WEBHOOK_URL}
	else
	    curl -X POST --data "payload={\"notificationType\": \"${NOTIFICATION_TYPE}\", \"notificationIssue\": \"${NAGIOS_NOTIFICATIONTYPE}\", \"hostData\": \"{\"hostName\": \"${NAGIOS_HOSTNAME}\", \"hostAddress\": \"${NAGIOS_HOSTADDRESS}\", \"hostState\": \"${NAGIOS_HOSTSTATE}\", \"hostStateType\": \"${NAGIOS_HOSTSTATETYPE}\", \"hostGroupName\": \"${NAGIOS_HOSTGROUPNAME}\", \"hostOutput\": \"${NAGIOS_HOSTOUTPUT}\", \"lastHostState\": \"${NAGIOS_LASTHOSTSTATE}\", \"lastHostOk\": \"${NAGIOS_LASTHOSTOK}\", \"hostAckAuthor\": \"${NAGIOS_HOSTACKAUTHOR}\", \"hostAckComment\": \"${NAGIOS_HOSTACKCOMMENT}\"}\"}" ${UPWORK_WEBHOOK_URL}
	fi
}

# The code above was placed in a function so you can easily notify multiple webhooks:
notifyUpwork "Webhook URL provided by Upwork when the integration was added"

