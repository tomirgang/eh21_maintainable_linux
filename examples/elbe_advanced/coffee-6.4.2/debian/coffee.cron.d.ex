#
# Regular cron jobs for the coffee package.
#
0 4	* * *	root	[ -x /usr/bin/coffee_maintenance ] && /usr/bin/coffee_maintenance
