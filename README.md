한국어
======

빠른 사용법
-----------

실행 환경:

* espeak, espeakedit, make, python(2.5+)이 설치된 환경
    * 우분투의 경우 패키지 관리자에서 직접 설치하거나, 다음 명령을 실행하면 됩니다: `sudo apt-get install espeak espeakedit make python`
* eSpeak 1.43.52 또는 이후 버전의 소스 코드가 espeak/에 있어야 합니다.
    * 잘 모르겠으면 git clone을 할 때 --recursive 옵션을 주면 됩니다: `git clone --recursive git://github.com/puzzlet/espeak-korean.git`

준비가 됐으면 다음을 실행시킵니다:

    make
    make speak

참고: 이 명령은 espeakedit의 기본 출력 경로인 `${HOME}/espeak-data/` 디렉토리를 초기화시킬 것입니다.




English
=======

Try it
------

You need:

* espeak, espeakedit, make, python(2.5+) installed
* source of eSpeak 1.43.52+ in espeak/
    * If you don't have no idea what to do, clone this with --recursive option in the first place: `git clone --recursive git://github.com/puzzlet/espeak-korean.git`

If everything is ready, try this:

    make
    make speak

Note: This will overwrite `${HOME}/espeak-data/`, which is the default output path for espeakedit.


More detail
-----------

`espeak-data/` contains the files to describe phonological rules of Korean language.  The `Makefile` copies them into `espeak/espeak-data/` and compiles the data.

We should note that eSpeak utilizes Unicode normalization, and when it comes to Korean, there is no easy way to manually edit the normalized characters.  So we edit `espeak-data/dictsource/ko_list.orig` and normalize it into `espeak-data/dictsource/ko_list` with a Python one-liner.

