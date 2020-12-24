
sudo yum -y install httpd scl-utils python27 psmisc wget 
alias python=/usr/bin/python2.7

sudo useradd cloudera-scm
sudo usermod -aG wheel cloudera-scm

sudo visudo
# add below lines
#cloudera-scm    ALL=(ALL)       NOPASSWD: ALL

sudo mkdir -p /var/www/html/{cm6,PARCEL}
sudo mkdir -p /var/www/html/cm6/{RPMS,repodata}
sudo mkdir -p /var/www/html/cm6/RPMS/x86_64

#Repodata
cd /var/www/html/cm6/repodata
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/3662f97de72fd44c017bb0e25cee3bc9398108c8efb745def12130a69df2ecb2-filelists.sqlite.bz2
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/43f3725f730ee7522712039982aa4befadae4db968c8d780c8eb15ae9872cd4d-primary.xml.gz
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/49e4d60647407a36819f1d8ed901258a13361749b742e3be9065025ad31feb8e-filelists.xml.gz
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/8afda99b921fd1538dd06355952719652654fc06b6cd14515437bda28376c03d-other.sqlite.bz2
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/b9300879675bdbc300436c1131a910a535b8b5a5dc6f38e956d51769b6771a96-primary.sqlite.bz2
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/e28836e19e07f71480c4dad0f7a87a804dc93970ec5277ad95614e8ffcff0d58-other.xml.gz
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/repomd.xml
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/repomd.xml.asc
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/repodata/repomd.xml.key

#RPMS
cd /var/www/html/cm6/RPMS/x86_64
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPMS/x86_64/cloudera-manager-agent-6.3.1-1466458.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPMS/x86_64/cloudera-manager-daemons-6.3.1-1466458.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPMS/x86_64/cloudera-manager-server-6.3.1-1466458.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPMS/x86_64/cloudera-manager-server-db-2-6.3.1-1466458.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPMS/x86_64/enterprise-debuginfo-6.3.1-1466458.el7.x86_64.rpm
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPMS/x86_64/oracle-j2sdk1.8-1.8.0+update181-1.x86_64.rpm

#RPM-KEY cloudera 
cd /var/www/html/cm6/
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/RPM-GPG-KEY-cloudera

#Parcel for CDH
cd /var/www/html/PARCEL
sudo wget https://archive.cloudera.com/cdh6/6.2.1/parcels/CDH-6.2.1-1.cdh6.2.1.p0.1425774-el7.parcel
sudo wget https://archive.cloudera.com/cdh6/6.2.1/parcels/CDH-6.2.1-1.cdh6.2.1.p0.1425774-el7.parcel.sha1
sudo wget https://archive.cloudera.com/cdh6/6.2.1/parcels/CDH-6.2.1-1.cdh6.2.1.p0.1425774-el7.parcel.sha256
sudo wget https://archive.cloudera.com/cdh6/6.2.1/parcels/manifest.json
sudo wget https://archive.cloudera.com/cm6/6.3.1/allkeys.asc

#Cloudera repo
cd /etc/yum.repos.d/ 
sudo wget https://archive.cloudera.com/cm6/6.3.1/redhat7/yum/cloudera-manager.repo

#add following lines to cloudera-manager.repo
# baseurl=http://127.0.0.1/cm6/RPMS/
# gpgkey=http://127.0.0.1/cm6/RPM-GPG-KEY-cloudera

sudo curl http://127.0.0.1/cm6/RPMS/
sudo yum install cloudera-manager-daemons cloudera-manager-server

#sudo yum install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm -y
#sudo yum install mysql-community-server-8.0.22-1.el8.x86_64.rpm
#sudo yum install mysql-community-server -y
#sudo systemctl start mysqld
#sudo systemctl enable mysqld.service

sudo wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo md5sum mysql80-community-release-el7-3.noarch.rpm
sudo rpm -i mysql80-community-release-el7-3.noarch.rpm
sudo yum install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
sudo mysql_secure_installation
mysql -uroot -p 
CREATE USER 'scm'@'localhost' IDENTIFIED BY 'scm_password';

cd
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
tar zxvf mysql-connector-java-5.1.46.tar.gz
sudo mkdir -p /usr/share/java/
sudo cp mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar

sudo yum install cloudera-manager-server

cd /etc/cloudera-scm-server
sudo vi db.properties

sudo /opt/cloudera/cm/schema/scm_prepare_database.sh -h 127.0.0.1 mysql scm scm scm_password
#sudo /usr/share/cmf/schema/scm_prepare_database.sh database-type mysql scm root 12345


CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON scm.* TO 'scm'@'localhost';

CREATE DATABASE amon DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON amon.* TO 'amon'@'%' IDENTIFIED BY 'amon_password';

CREATE DATABASE rman DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON rman.* TO 'rman'@'%' IDENTIFIED BY 'rman_password';

CREATE DATABASE metastore DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON metastore.* TO 'metastore'@'%' IDENTIFIED BY 'metastore_password';

CREATE DATABASE sentry DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON sentry.* TO 'sentry'@'%' IDENTIFIED BY 'sentry_password';

CREATE DATABASE nav DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON nav.* TO 'nav'@'%' IDENTIFIED BY 'nav_password';

CREATE DATABASE navms DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON navms.* TO 'navms'@'%' IDENTIFIED BY 'navms_password';

CREATE DATABASE oozie DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON oozie.* TO 'oozie'@'%' IDENTIFIED BY 'oozie_password';

CREATE DATABASE hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON hue.* TO 'hue'@'%' IDENTIFIED BY 'hue_password';

CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'scm_password';

sudo systemctl restart cloudera-scm-server
sudo systemctl enable cloudera-scm-server
