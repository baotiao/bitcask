CXX = g++
ifeq ($(__PERF), 1)
	CXXFLAGS = -O0 -g -pg -pipe -fPIC -DLOG_LEVEL=DEBUG -W -Wwrite-strings -Wpointer-arith -Wreorder -Wswitch -Wsign-promo -Wredundant-decls -Wformat -Wall -D_GNU_SOURCE -std=c++11 -D__STDC_FORMAT_MACROS -std=c++11 -gdwarf-2 -Wno-redundant-decls -D__XDEBUG__
else
	CXXFLAGS = -O2 -g -pipe -fPIC -W -Wwrite-strings -Wpointer-arith -Wreorder -Wswitch -Wsign-promo -Wredundant-decls -Wformat -Wall -D_GNU_SOURCE -D__STDC_FORMAT_MACROS -std=c++11 -gdwarf-2 -Wno-redundant-decls
endif

OBJECT = bitcask
SRC_DIR = ./src
THIRD_PATH = ./third
OUTPUT = ./output

INCLUDE_PATH = -I./ \
							 -I$(THIRD_PATH)/

LIB_PATH = -L$(THIRD_PATH)/slash/output/lib/

LIBS = -lpthread \
			 -lslash

LIBRARY = libbitcask.a

BT = bt

.PHONY: all clean

BASE_OBJS := $(wildcard $(SRC_DIR)/*.cc)
OBJS = $(patsubst %.cc,%.o,$(BASE_OBJS))

LIBSLASH = $(THIRD_PATH)/slash/output/lib/libslash.a

all: $(BT)
	@echo "Success, go, go, go..."

$(LIBSLASH):
	make -C $(THIRD_PATH)/slash/

$(BT): $(SLASH) $(OBJS)
	  $(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(INCLUDE_PATH) $(LIB_PATH) $(LFLAGS) $(LIBS)

$(LIBRARY): $(LIBSLASH) $(OBJS)
	rm -rf $(OUTPUT)
	mkdir $(OUTPUT)
	mkdir $(OUTPUT)/include
	mkdir $(OUTPUT)/lib
	rm -rf $@
	ar -rcs $@ $(OBJS)
	cp -r ./include $(OUTPUT)/
	mv $@ $(OUTPUT)/lib/
	# make -C example __PERF=$(__PERF)

$(OBJECT): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(INCLUDE_PATH) $(LIB_PATH) -Wl,-Bdynamic $(LIBS)

$(OBJS): %.o : %.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@ $(INCLUDE_PATH) 

clean: 
	make clean -C example
	rm -rf $(SRC_DIR)/*.o
	rm -rf $(OUTPUT)/*
	rm -rf $(OUTPUT)
	rm -rf bt
