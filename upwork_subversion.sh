#!/bin/sh

# POST-COMMIT HOOK
#
# The post-commit hook is invoked after a commit.  Subversion runs
# this hook by invoking a program (script, executable, binary, etc.)
# named 'post-commit' (for which this file is a template) with the 
# following ordered arguments:
#
#   [1] REPOS-PATH   (the path to this repository)
#   [2] REV          (the number of the revision just committed)
#
# Note that 'post-commit' must be executable by the user(s) who will
# invoke it (typically the user httpd runs as), and that user must
# have filesystem-level permission to access the repository.
#
# On a Windows system, you should name the hook program
# 'post-commit.bat' or 'post-commit.exe',
# but the basic idea is the same.

REPOS="$1"
REV="$2"

# No environment is passed to svn hook scripts; set paths to external tools explicitly:
SVNLOOK=/usr/bin/svnlook
CURL=/usr/bin/curl
HOME=/var/www/

REPOS_URL="" # OPTIONAL - Set this to the url of your Repository. Ex: http://svnserver/wsvn/main/?op=repository&repository=$REPOS
REV_URL="" # OPTIONAL - Set this to the url of your commit Revision. Ex: http://svnserver/wsvn/main/?op=revision&rev=$REV

AUTHOR=`$SVNLOOK author --revision $REV $REPOS`
LOG=`$SVNLOOK log --revision $REV $REPOS`
CHANGES=`$SVNLOOK changed --revision $REV $REPOS`
CHANGES=$(echo "$CHANGES" | sed "s/.*/\"&\"/" | tr '\n' ',' | sed 's/.$//')

function notifyUpwork {
	UPWORK_WEBHOOK_URL=$1
	$CURL -X POST -H "Content-Type: application/json" ${UPWORK_WEBHOOK_URL} -d '{"payload":{"author": "'"$AUTHOR"'", "log": "'"$LOG"'", "changes": ['"$CHANGES"'], "revision": "'"$REV"'", "repository": "'"$REPOS"'", "repositoryUrl": "'"$REPOS_URL"'", "revisionUrl": "'"$REV_URL"'"}}'
}

# The code above was placed in a function so you can easily notify multiple webhooks:
notifyUpwork "Webhook URL provided by Upwork when the integration was added"
