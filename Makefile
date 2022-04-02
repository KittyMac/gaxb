all:
	mkdir -p build && cd build && cmake .. && make

setup:
	git submodule update --init lua
	brew install cmake