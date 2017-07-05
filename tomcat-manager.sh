#!/bin/bash

# Script for managing tomcat server
# Script By : Laxman Singh <laxman.nrlm@gmail.com>
# Developed On : 8th June, 2016

RED='\033[0;31m'
GREEN='\033[32m'
ORANGE='\033[33m'
BLUE='\033[34m'
NC='\033[0m'
CYAN='\033[35m'


TOMCAT_DIR=/usr/share/tomcat7
#TOMCAT_DIR=/extra/software/apache-tomcat-8.0.32
SHUTDOWN_WAIT=30

# show error message if no argument passed
NO_OF_ARG=$#
ARG=$1
if [[ $NO_OF_ARG -eq 0 ]]; then
	echo -e "${RED}USAGE:\ttomcat-manager {start|stop|status|restart|help}${NC}"; exit 1
fi

main() {
	# welcome message
	echo -e "\n${BLUE}===================================== Tomcat Manager ===============================================${NC}"
}
	
 
start() {
	
	pid=$(tomcat_pid)
	if [[ -n "$pid" ]]; then
		echo -e "${RED}Tomcat already running with pid ($pid). to restart use (restart) option.${NC}"
	else
		echo -e "${GREEN}Starting tomcat ..... Please wait...!!!${NC}"
		echo -ne "#############"
		$TOMCAT_DIR/bin/catalina.sh start
		if [[ $? -eq "0" ]]; then
			echo -e "${GREEN}Tomcat started successfully..!!${NC}"
		else
			echo -e "${RED}Tomcat failed to start... Please see tomcat startup log..${NC}"
			echo -e "${BLUE}to see logs :: #tailf $TOMCAT_DIR/logs/catalina.out${NC}"
		fi
	fi
}

status() {
	pid=$(tomcat_pid)
        if [[ -n "$pid" ]]; then
		echo -e "${GREEN}Tomcat is running with pid :${ORANGE} \t" $pid"${NC}"
	else 
		echo -e "${RED}Tomcat not Running${NC}"
	fi
}

stop() {
	pid=$(tomcat_pid)
  			
	if [[ -n "$pid" ]]; then
		echo -e "${BLUE}Stopping tomcat.. Please wait...${ORANGE} it may take a while....${NC}"
		$TOMCAT_DIR/bin/catalina.sh stop
 
    		let kwait=$SHUTDOWN_WAIT
    		count=0;
    		until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    		do
      			echo -ne "${BLUE}################${NC}\n";
      			sleep 1
      			let count=$count+1;
    		done
 
    		if [ $count -gt $kwait ]; then
      			echo -n -e "${RED}killing processes didn't stop after $SHUTDOWN_WAIT seconds${NC}\n"
     			terminate
    		fi
  	else
    		echo -e "${RED}Tomcat is not running${NC}"
  	fi
}

restart() {	
	stop
	start
}
show_help() {
	echo -e "${GREEN}===================== USAGE =============================================================================\n"
	
	echo -e "It accepts following parameters as:"
	echo -e "start\tIt starts the tomcat server\nstop\tStops the tomcat server\nstatus\tShows the status of tomcat server"
	echo -e "restart\tRestarts the tomcat service"
	echo -e "help\tShows the help${NC}"
}

	
		
	
tomcat_pid() {
        echo `ps -ef | grep $TOMCAT_DIR | grep -v grep | tr -s " "|cut -d" " -f2`
}

terminate() {
	echo -e "${RED}Terminating Tomcat forcefully ....${NC}"
	kill -9 $(tomcat_pid)
}

# execute program
clear
main
case $ARG in
	"start" )
		start;;
	"stop" )
		stop;;
	"status" )
		status;;
	"restart" )
		restart;;
	
	"help" )
		show_help;;
	* )
		echo -e "${RED}Invalid Parameter..";
		echo -e "${RED}USAGE:\tnrlm-tomcat {start|stop|status|restart|help}${NC}";;
esac

echo -e "${ORANGE}==========================================================================================================${NC}\n\n"
