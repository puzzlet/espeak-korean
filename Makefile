EMSCRIPTEN_PREFIX = `dirname \`command -v emcc\``

PHON_FILES = phontab phonindex phondata intonations
DICT_FILES = en_dict ko_dict
DATA_FILES = $(PHON_FILES) $(DICT_FILES)
DATA_FILES_TARGET = $(addprefix espeak-korean/espeak-data/,$(DATA_FILES))

all: src/speakGenerator.debug.js src/speakGenerator.js

$(DATA_FILES_TARGET):
	( cd espeak-korean/; make )

src/data.js:
	if [ ! -d src/data/ ]; then mkdir -p src/data/; fi
	$(foreach f,$(DATA_FILES),\
	    python "$(EMSCRIPTEN_PREFIX)/tools/file2json.py" "espeak-korean/espeak-data/$(f)" "$(f)" > "src/data/$(f).js"; \
	)
	python "$(EMSCRIPTEN_PREFIX)/tools/file2json.py" espeak-korean/espeak/espeak-data/voices/en/en-us en_us > src/data/en-us.js
	python "$(EMSCRIPTEN_PREFIX)/tools/file2json.py" espeak-korean/espeak-data/voices/ko ko > src/data/ko.js
	python "$(EMSCRIPTEN_PREFIX)/tools/file2json.py" speak.js/espeak-data/config config > src/data/config.js
	cat $(patsubst %,src/data/%.js,$(DATA_FILES)) src/data/en-us.js src/data/ko.js src/data/config.js > src/data.js

src/speak.bc:
	if [ ! -d src/ ]; then mkdir -p src/; fi
	cd speak.js/src/; \
	    make distclean; make clean; \
	    rm -f libspeak.* speak speak.o; \
	    CXXFLAGS="-DNEED_WCHAR_FUNCTIONS" $(EMSCRIPTEN_PREFIX)/emmake make -j 2 ../../src/speak.bc

src/pre.js: src/_pre.js
	cat src/_pre.js src/data.js > src/pre.js

src/post.js: src/data.js src/_post.js
	cat src/_post.js > src/post.js

src/speak.debug.js: src/speak.bc src/pre.js src/post.js
	cd $(EMSCRIPTEN_PREFIX)/src/; \
	    mv preamble.js preamble.js.bak; \
	    cat preamble.js.bak | sed -r 's/function intArrayFromString.*$$/\0\nstringy=unescape(encodeURIComponent(stringy));/' > preamble.js
	$(EMSCRIPTEN_PREFIX)/emcc -O0 src/speak.bc --pre-js src/pre.js --post-js src/post.js -o src/speak.debug.js
	cd $(EMSCRIPTEN_PREFIX)/src/; \
	    rm preamble.js; \
	    mv preamble.js.bak preamble.js

src/speak.js: src/speak.bc src/pre.js src/post.js
	cd $(EMSCRIPTEN_PREFIX)/src/; \
	    mv preamble.js preamble.js.bak; \
	    cat preamble.js.bak | sed -r 's/function intArrayFromString.*$$/\0\nstringy=unescape(encodeURIComponent(stringy));/' > preamble.js
	$(EMSCRIPTEN_PREFIX)/emcc -O2 src/speak.bc --pre-js src/pre.js --post-js src/post.js -o src/speak.js
	cd $(EMSCRIPTEN_PREFIX)/src/; \
	    rm preamble.js; \
	    mv preamble.js.bak preamble.js

src/speakGenerator.debug.js: src/speak.debug.js
	cat speak.js/src/shell_pre.js src/speak.debug.js speak.js/src/shell_post.js > src/speakGenerator.debug.js

src/speakGenerator.js: src/speak.js
	cat speak.js/src/shell_pre.js src/speak.js speak.js/src/shell_post.js > src/speakGenerator.js

