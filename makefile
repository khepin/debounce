default:
	rm -rf dist
	mkdir dist
	raco exe --orig-exe debounce.rkt
	mv debounce dist