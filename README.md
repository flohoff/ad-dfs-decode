
In case of a desaster recovery e.g. Ransomware you might be able to fetch a 
**ldifde** export from one of your *Active Directory* servers. This dump may help
you to find a lot of informations.

For example the AD dump contains the DFS (Distributed FileSystem) Namespaces,
targets etc.

Its a bit tricky to decode that information as Microsoft choose to make it extra
hard as they have a base64 encoder bug (Misplacing \ and /) and other strange 
ideas of putting a UTF-16 XML (with BOM) as base64 into an AD objects key.

LDIF example
------------

	dn: CN=DEHR,CN=DEHR,CN=Dfs-Configuration,CN=System,DC=domain,DC=de
	changetype: add
	objectClass: top
	objectClass: msDFS-Namespacev2
	cn: DEHR
	[ ... ]
	msDFS-GenerationGUIDv2:: 1iC7RgVKU4Hk0lgAkz4q==
	msDFS-NamespaceIdentityGUIDv2:: OuDrOqrec0x0mP5KW47G==
	msDFS-LastModifiedv2: 20221209084040.0Z
	msDFS-Ttlv2: 300
	msDFS-Propertiesv2: ABDE=on
	msDFS-Propertiesv2: ReferralSiteCosting=on
	msDFS-Propertiesv2: State=okay
	msDFS-TargetListv2::
	 //48ad8aabTagWaiab2auaCGbZagKaBWbUad0aiGaXac4amaaIaAAZQBuAGMAbBkAGkAbgBnAD
	 [ ... ]

Installation
============ 

	apt-get install libfile-slurp-perl libgetopt-long-descriptive-perl \
		libxml-simple-perl libtext-iconv-perl

Extract DFS Namespace and Targets
=================================

	./decode-dfs --ldif adds/ad.ldf
	DEHR;/HR;0;siteCostNormal;\\SVFS12\DEHR;
	DEHR;/HR;0;siteCostNormal;\\SVFS1\DEHR;

Extract shared mailboxes access
===============================

	./shared-mailboxes -l adds/ad.ldf
	Boss, Big;CN=Boss\, Big,OU=User,OU=Elite,DC=domain,DC=de;;
	;;CN=Secretary\, My,OU=Organisation,DC=Domain,DC=de;
	[ ... ]

Extract mailbox quota
=====================

	./mailquota -l adds/ad.ldif
	samaccountname;dn;company;msExchArchiveQuota;msExchArchiveWarnQuota;msExchDumpsterQuota;msExchDumpsterWarningQuota;Addresses
	Boss, Big,CN=Boss\, Big,DC=domain,DC=de;;104857600;94371840;31457280;20971520;,,,,,,,,,,,,,,,,,,,,,,,,,,

Extract DN SID pairs
====================

	./dnsid -l adds/ad.ldif \
		| sort -t- -n -k 2 -k 3 -k 4 -k 5 -k 6 -k 7 -k 8 \
		>dnsid.csv
