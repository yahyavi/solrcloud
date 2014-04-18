SolrCloud
=========

Scripts for testing SolrCloud performance. 

These are scripts and code I wrote for a short-term 5 week project on testing Solr perofrmance. See report.pdf for complete description of what scripts do and how to use them, and the initial results.


==================================================
Table 1: Table of scripts
--------------------------------------------------
clean.sh	Cleans XML data files of non-utf and control characters that cause Post utility to crash. Currently it doesn’t enforce ASCII coding but if that’s necessary, change the command in the script to the commented ASCII version.
--------------------------------------------------
index.sh	Will use Post utility on local node\#1, with the XML datafile \#2.
--------------------------------------------------
newzk.sh	Used to create a new local zookeeper node and to start it.
--------------------------------------------------
split.sh	Used to split a very large xml file \#1 into \#2 files with the same number of lines. It is mostly used for files larger than 1.5GB. The last doc inside the split file must be handled/corrected manually.
--------------------------------------------------
config.sh	The main configuration file.  Must be adjusted to reflect the parameters in your setup including different folders, number of nodes, shards, etc.
--------------------------------------------------
install.sh	Extracts (if cannot find the file, downloads it) the Solr and Zookeeper. If the download link doesn’t work replace with another server from Solr/Zookeeper page. Also generates the properties file.
--------------------------------------------------
oldrmnodes.sh	Removes local nodes.	Deprecated  by  rmremotenodes.sh.
--------------------------------------------------
startnodes.sh	Connects and to existing nodes and starts them with their current configs.
--------------------------------------------------
deploynodes.sh	Main script for testing. Kills/removes existing nodes, configs, zookeepers. Creates new zookeepers and Solr nodes and starts them up. It also asks to whether index the default data files indicated in the config file or not. The parameters are configured in config.sh.
--------------------------------------------------
killremotenodes.sh	Connects to different hosts and zookeepers and kills their process. It does not remove the nodes.
--------------------------------------------------
rmremotenodes.sh	Same as kill except it also removes the nodes.
--------------------------------------------------
utils.sh	Includes a couple of common commands used by sev- eral scripts.
--------------------------------------------------
genprop.sh	Creates a properties files to be used by the SolrJ file.
--------------------------------------------------
newnode.sh	Creates a new local node \#1, also passes the rest of parameters used to the starting Solr server.  Copies the config files from config path.
--------------------------------------------------
smaller.sh	This is used for quick testing.  Creates smaller files with n lines named U-”filename” which can be used for quick deployment and testing.
--------------------------------------------------
zkdeploy.sh	Creates and starts new local zookeeper nodes according to config.sh properties.

==================================================
Table 2: Table of folders
--------------------------------------------------
Solrj	Contains the SolrJ java sources that are designed to read and stress the servers using the q.txt queries. You can create a jar file using the build.xml file to easily deploy and run this. It creates a num threads threads as defined in the config.sh file.
--------------------------------------------------
data	Contains the main XML data files (with current de- fault name Solrn\#.xml) and a queries file called q.txt
--------------------------------------------------
configs	Contains the schema and solrconfig files.
--------------------------------------------------
zk	Only exists so so zookeeper id files can be created.
--------------------------------------------------
logs.tar.gz	The logs from my runs






Please see report.pdf
