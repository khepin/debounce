default:
	rm -rf dist
	mkdir dist
	raco exe debounce.rkt
	mv debounce dist