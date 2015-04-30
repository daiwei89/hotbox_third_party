THIRD_PARTY := $(shell readlink $(dir $(lastword $(MAKEFILE_LIST))) -f)
THIRD_PARTY_CENTRAL = $(THIRD_PARTY)/central
THIRD_PARTY_SRC = $(THIRD_PARTY)/src
THIRD_PARTY_INCLUDE = $(THIRD_PARTY)/include
THIRD_PARTY_LIB = $(THIRD_PARTY)/lib
THIRD_PARTY_BIN = $(THIRD_PARTY)/bin

third_party_core: path \
	                gflags \
                  glog \
                  gperftools \
								  snappy \
                  sparsehash \
									fastapprox


third_party_all: third_party_core \
                  oprofile \
									boost \
									eigen

distclean:
	rm -rf $(THIRD_PARTY_INCLUDE) $(THIRD_PARTY_LIB) $(THIRD_PARTY_BIN) \
		$(THIRD_PARTY_SRC) $(THIRD_PARTY)/share

# These might not build.
third_party_unused: gtest \
										libcuckoo \
										iftop \
										leveldb

.PHONY: third_party_core third_party_all third_party_unused distclean

path:
	mkdir -p $(THIRD_PARTY_LIB)
	mkdir -p $(THIRD_PARTY_INCLUDE)
	mkdir -p $(THIRD_PARTY_BIN)
	mkdir -p $(THIRD_PARTY_SRC)

# ==================== boost ====================

BOOST_SRC = $(THIRD_PARTY_CENTRAL)/boost_1_58_0.tar.bz2
BOOST_INCLUDE = $(THIRD_PARTY_INCLUDE)/boost

boost: $(BOOST_INCLUDE)

$(BOOST_INCLUDE): $(BOOST_SRC)
	tar jxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./bootstrap.sh \
		--prefix=$(THIRD_PARTY); \
	./b2 install

# ==================== boost ====================

EIGEN_SRC = $(THIRD_PARTY_CENTRAL)/eigen-3.2.4.tar.bz2
EIGEN_INCLUDE = $(THIRD_PARTY_INCLUDE)/eigen

eigen: $(EIGEN_INCLUDE)

$(EIGEN_INCLUDE): $(EIGEN_SRC)
	tar jxf $< -C $(THIRD_PARTY_SRC)
	cp -r $(THIRD_PARTY_SRC)/eigen-eigen-10219c95fe65/Eigen \
		$(THIRD_PARTY_INCLUDE)/

# ==================== fastapprox ===================

FASTAPPROX_SRC = $(THIRD_PARTY_CENTRAL)/fastapprox-0.3.2.tar.gz
FASTAPPROX_INC = $(THIRD_PARTY_INCLUDE)/fastapprox

fastapprox: $(FASTAPPROX_INC)

$(FASTAPPROX_INC): $(FASTAPPROX_SRC)
	tar xzf $< -C $(THIRD_PARTY_SRC)
	mkdir $(THIRD_PARTY_INCLUDE)/fastapprox
	cp $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<)))/src/*.h \
		$(THIRD_PARTY_INCLUDE)/fastapprox

# ===================== gflags ===================

GFLAGS_SRC = $(THIRD_PARTY_CENTRAL)/gflags-2.0.tar.gz
GFLAGS_LIB = $(THIRD_PARTY_LIB)/libgflags.so

gflags: $(GFLAGS_LIB)

$(GFLAGS_LIB): $(GFLAGS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ===================== glog =====================

GLOG_SRC = $(THIRD_PARTY_CENTRAL)/glog-0.3.3.tar.gz
GLOG_LIB = $(THIRD_PARTY_LIB)/libglog.so

glog: $(GLOG_LIB)

$(GLOG_LIB): $(GLOG_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ================== gperftools =================

GPERFTOOLS_SRC = $(THIRD_PARTY_CENTRAL)/gperftools-2.4.tar.gz
GPERFTOOLS_LIB = $(THIRD_PARTY_LIB)/libtcmalloc.so

gperftools: $(GPERFTOOLS_LIB)

$(GPERFTOOLS_LIB): $(GPERFTOOLS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY) --enable-frame-pointers; \
	make install

# =================== oprofile ===================
# NOTE: need libpopt-dev binutils-dev

OPROFILE_SRC = $(THIRD_PARTY_CENTRAL)/oprofile-1.0.0.tar.gz
OPROFILE_LIB = $(THIRD_PARTY_LIB)/oprofile

oprofile: $(OPROFILE_LIB)

$(OPROFILE_LIB): $(OPROFILE_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ================== sparsehash ==================

SPARSEHASH_SRC = $(THIRD_PARTY_CENTRAL)/sparsehash-2.0.2.tar.gz
SPARSEHASH_INCLUDE = $(THIRD_PARTY_INCLUDE)/sparsehash

sparsehash: $(SPARSEHASH_INCLUDE)

$(SPARSEHASH_INCLUDE): $(SPARSEHASH_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ==================== snappy ===================

SNAPPY_SRC = $(THIRD_PARTY_CENTRAL)/snappy-1.1.2.tar.gz
SNAPPY_LIB = $(THIRD_PARTY_LIB)/libsnappy.so

snappy: $(SNAPPY_LIB)

$(SNAPPY_LIB): $(SNAPPY_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ==================== zeromq ====================

ZMQ_SRC = $(THIRD_PARTY_CENTRAL)/zeromq-3.2.5.tar.gz
ZMQ_LIB = $(THIRD_PARTY_LIB)/libzmq.so

zeromq: $(ZMQ_LIB)

$(ZMQ_LIB): $(ZMQ_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install
	cp $(THIRD_PARTY_CENTRAL)/zmq.hpp $(THIRD_PARTY_INCLUDE)


####################### Unused #####################

# ===================== gtest ====================

GTEST_SRC = $(THIRD_PARTY_CENTRAL)/gtest-1.7.0.tar
GTEST_LIB = $(THIRD_PARTY_LIB)/libgtest_main.a

gtest: $(GTEST_LIB)

$(GTEST_LIB): $(GTEST_SRC)
	tar xf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $<)/make; \
	make; \
	./sample1_unittest; \
	cp -r ../include/* $(THIRD_PARTY_INCLUDE)/; \
	cp gtest_main.a $@

# ===================== libcuckoo =====================

CUCKOO_SRC = $(THIRD_PARTY_CENTRAL)/libcuckoo.tar
CUCKOO_INCLUDE = $(THIRD_PARTY_INCLUDE)/libcuckoo

cuckoo: $(CUCKOO_INCLUDE)

$(CUCKOO_INCLUDE): $(CUCKOO_SRC)
	tar xf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	autoreconf -fis; \
	./configure --prefix=$(THIRD_PARTY); \
	make; make install

# ================== iftop ==================

IFTOP_SRC = $(THIRD_PARTY_CENTRAL)/iftop-1.0pre4.tar.gz
IFTOP_BIN = $(THIRD_PARTY_BIN)/iftop

iftop: $(IFTOP_BIN)

$(IFTOP_BIN): $(IFTOP_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install; \
	cp iftop $(IFTOP_BIN)

# ==================== leveldb ===================

LEVELDB_SRC = $(THIRD_PARTY_CENTRAL)/leveldb-1.15.0.tar.gz
LEVELDB_LIB = $(THIRD_PARTY_LIB)/libleveldb.so

leveldb: $(LEVELDB_LIB)

$(LEVELDB_LIB): $(LEVELDB_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	LIBRARY_PATH=$(THIRD_PARTY_LIB):${LIBRARY_PATH} \
	make; \
	cp ./libleveldb.* $(THIRD_PARTY_LIB)/; \
	cp -r include/* $(THIRD_PARTY_INCLUDE)/