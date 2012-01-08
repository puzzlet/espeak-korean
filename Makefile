all: espeak-data/en_dict espeak-data/ko_dict

espeak-data/phontab: espeak-data/phsource/ph_korean espeak-data/phsource/phonemes.append espeak-data/voices/ko
	rsync -aCv espeak/espeak-data/ ${HOME}/espeak-data/
#	rsync -aCv espeak/dictsource/ ${HOME}/espeak-data/dictsource/
	rsync -aCv espeak/phsource/ ${HOME}/espeak-data/phsource/
	cp espeak-data/phsource/ph_korean ${HOME}/espeak-data/phsource/
	cp espeak-data/voices/ko ${HOME}/espeak-data/voices/
	cat espeak-data/phsource/phonemes.append >> ${HOME}/espeak-data/phsource/phonemes
	espeakedit --compile
	cp ${HOME}/espeak-data/phontab espeak-data/
	cp ${HOME}/espeak-data/phonindex espeak-data/
	cp ${HOME}/espeak-data/phondata espeak-data/

espeak-data/en_dict: espeak-data/phontab
	cd espeak/dictsource/; espeak --compile=en
	cp ${HOME}/espeak-data/en_dict espeak-data/

espeak-data/ko_dict: espeak-data/phontab espeak-data/dictsource/ko_list.orig espeak-data/dictsource/ko_rules
	python -c "import sys,unicodedata;sys.stdout.write(unicodedata.normalize('NFKD', sys.stdin.read().decode('utf8')).replace(u'\u110B',u'').encode('utf8'))" < espeak-data/dictsource/ko_list.orig > espeak-data/dictsource/ko_list
	cd espeak-data/dictsource/; espeak --compile=ko --path=../..
	cp espeak-data/ko_dict ${HOME}/espeak-data/

speak:
	espeak -v ko -X --path=${HOME} '안녕하세요 보이스 피싱입니다'

clean:
	rm -R espeak-data/phontab espeak-data/phonindex espeak-data/phondata
	rm -R espeak-data/en_dict espeak-data/ko_dict

