#!/bin/bash

if [ -z "$JAVA_HOME" ] || [ -z "$MAVEN_HOME" ] || [ -z "$GLASSFISH_HOME" ]
then
	echo Environment variable JAVA_HOME, MAVEN_HOME or GLASSFISH_HOME not set; exit
fi

export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$GLASSFISH_HOME/bin:$PATH

export GF_DOMAIN=bookstore
export GF_ADMIN_USER=admin
export GF_ADMIN_PASSWORD=

export DATASOURCE_NAME=jdbc/bookstore
export DB_HOST=localhost
export DB_PORT=1527
export DB_HOME=$GLASSFISH_HOME/javadb/data
export DB_NAME=bookstore
export DB_USER=app
export DB_PASSWORD=app

export JMS_QUEUE_NAME=jms/orderQueue
export JMS_CONNECTION_FACTORY=jms/connectionFactory

export MAIL_SESSION_NAME=mail/bookstore
export MAIL_HOST=hermes.bfh.ch
export MAIL_PORT=25
export MAIL_USER_NAME=
export MAIL_USER_PASSWORD=
export MAIL_USER_ADDRESS=

export APPLICATION_NAME=bookstore
export CONTEXT_ROOT=bookstore


createDomain() {
	echo
	echo "********************************************************************************"
	echo "*** Creating GlassFish domain..."
	echo "********************************************************************************"
	read -p "GlassFish admin password: " GF_ADMIN_PASSWORD
	echo AS_ADMIN_PASSWORD=$GF_ADMIN_PASSWORD> password.txt
	asadmin --user $GF_ADMIN_USER --passwordfile password.txt create-domain --savelogin true $GF_DOMAIN
	rm password.txt
}

startServers() {
	echo
	echo "********************************************************************************"
	echo "*** Starting Java DB server..."
	echo "********************************************************************************"
	asadmin start-database --dbhost=$DB_HOST --dbport=$DB_PORT --dbhome=$DB_HOME
	echo
	echo "*** Starting GlassFish server..."
	asadmin start-domain $GF_DOMAIN
}

configureDomain() {
	echo
	echo "********************************************************************************"
	echo "*** Creating JDBC data source..."
	echo "********************************************************************************"
	asadmin create-jdbc-connection-pool --datasourceclassname org.apache.derby.jdbc.ClientDataSource --restype javax.sql.DataSource --property ServerName=$DB_HOST:Port=$DB_PORT:DatabaseName=$DB_NAME:User=$DB_USER:Password=$DB_PASSWORD:ConnectionAttributes='create\=true' ConnectionPool
	asadmin create-jdbc-resource --connectionpoolid ConnectionPool $DATASOURCE_NAME
	echo
	echo "********************************************************************************"
	echo "*** Creating JMS message queue and connection factory..."
	echo "********************************************************************************"
	asadmin create-jmsdest --desttype queue PhysicalQueue
	asadmin create-jms-resource --restype javax.jms.Queue --property Name=PhysicalQueue $JMS_QUEUE_NAME
	asadmin create-jms-resource --restype javax.jms.ConnectionFactory $JMS_CONNECTION_FACTORY
	echo
	echo "********************************************************************************"
	echo "*** Creating JavaMail session..."
	echo "********************************************************************************"
	read -p "Mail user name: " MAIL_USER_NAME
	read -p "Mail user password: " MAIL_USER_PASSWORD
	read -p "Mail user address: " MAIL_USER_ADDRESS
	asadmin create-javamail-resource --mailhost $MAIL_HOST --mailuser $MAIL_USER_NAME --fromaddress=$MAIL_USER_ADDRESS --property mail.smtp.port=$MAIL_PORT:mail.smtp.auth=true:mail.smtp.password=$MAIL_USER_PASSWORD:mail.smtp.starttls.enable=true $MAIL_SESSION_NAME
}

buildApplication() {
	echo
	echo "********************************************************************************"
	echo "*** Building Bookstore application..."
	echo "********************************************************************************"
	mvn clean install
}

deployApplication() {
	echo
	echo "********************************************************************************"
	echo "*** Deploying Bookstore application..."
	echo "********************************************************************************"
	asadmin deploy --force=true $APPLICATION_NAME-app/target/*.ear
	echo Application available at http://localhost:8080/$CONTEXT_ROOT
}

runIntegrationTests() {
	echo
	echo "********************************************************************************"
	echo "*** Running Bookstore integration tests..."
	echo "********************************************************************************"
	mvn failsafe:integration-test failsafe:verify
}

undeployApplication() {
	echo
	echo "********************************************************************************"
	echo "*** Undeploying Bookstore application..."
	echo "********************************************************************************"
	asadmin undeploy $APPLICATION_NAME-app
	echo
	echo "********************************************************************************"
	echo "*** Cleaning Bookstore application..."
	echo "********************************************************************************"
	mvn clean
}

stopServers() {
	echo
	echo "********************************************************************************"
	echo "*** Stopping GlassFish server..."
	echo "********************************************************************************"
	asadmin stop-domain $GF_DOMAIN
	echo
	echo "********************************************************************************"
	echo "*** Stopping Java DB server..."
	echo "********************************************************************************"
	asadmin stop-database --dbhost=$DB_HOST --dbport=$DB_PORT
}

deleteDomain() {
	echo
	echo "********************************************************************************"
	echo "*** Deleting GlassFish domain..."
	echo "********************************************************************************"
	asadmin delete-domain $GF_DOMAIN
}

while true;
do
	clear
	echo 1 - Create GlassFish domain
	echo 2 - Start GlassFish and Java DB server
	echo 3 - Configure GlassFish domain
	echo 4 - Build Bookstore application
	echo 5 - Deploy Bookstore application
	echo 6 - Run Bookstore integration tests
	echo 7 - Undeploy and clean Bookstore application
	echo 8 - Stop GlassFish and Java DB server
	echo 9 - Delete GlassFish domain
	echo x - Exit
	echo
	read -p "Choice: " choice
	case $choice in
		1) createDomain;;
		2) startServers;;
		3) configureDomain;;
		4) buildApplication;;
		5) deployApplication;;
		6) runIntegrationTests;;
		7) undeployApplication;;
		8) stopServers;;
		9) deleteDomain;;
		x) exit;;
	esac
	echo
	read -p "Press any key to continue..."
done
