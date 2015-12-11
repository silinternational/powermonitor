include version.txt

output = ../output
productname = outbackpower-$(version)
tardest = $(output)/$(productname)

outbackpower : 
	rm -rf $(tardest)
	mkdir $(tardest)
	#gcc -o queryMateSerial queryMateSerial.c
	cp -r ./queryMateSerial $(tardest)/
	cp ./queryMateSerial.c $(tardest)/
	cp -r ./scripts/* $(tardest)/
	cp ./version.txt $(tardest)/
	cp ./lgpl.txt $(tardest)/
	chown root:root $(tardest)/ -R
	chmod 700 $(tardest)/*.sh
	chmod 700 $(tardest)/*.pl
	chmod 700 $(tardest)/queryMateSerial
	cd $(output)/ && tar -cz --exclude-vcs -f $(productname).tgz $(productname)/

clean :
	rm -fr $(tardest)
