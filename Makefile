all:
	rsync -aCv espeak/espeak-data/ ${HOME}/espeak-data/
	rsync -aCv espeak/dictsource/ ${HOME}/espeak-data/dictsource/
	rsync -aCv espeak/phsource/ ${HOME}/espeak-data/phsource/
	cp espeak-data/dictsource/ko_list espeak-data/dictsource/ko_rules ${HOME}/espeak-data/dictsource/
	cp espeak-data/phsource/ph_korean ${HOME}/espeak-data/phsource/
	cp espeak-data/voices/ko ${HOME}/espeak-data/voices/
	cat espeak-data/phsource/phonemes.append >> ${HOME}/espeak-data/phsource/phonemes
	espeakedit --compile
	cd espeak-data/dictsource/; espeak --compile=ko

speak:
	espeak -v ko -X --path=${HOME} '안녕하세요 보이스 피싱입니다'

