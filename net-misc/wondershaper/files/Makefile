.PHONY: all
all: wondershaper.config wondershaper

wondershaper.config:
	tail -n+2 wshaper \
	| awk '/^# Now remove/{firstPartOver=1}{if (! firstPartOver) print $0}' \
	>> $@
wondershaper: wshaper
	cp rc.skel $@
	awk '/^if \[/{firstPartOver=1}{if (firstPartOver) print $0}' $^ \
	| awk -f append-return-1.awk \
	| sed 's/exit/return 0/' >> $@
	echo "}" >> $@

clean:
	rm wondershaper wondershaper.config