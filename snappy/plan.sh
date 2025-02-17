pkg_origin=core
pkg_name=snappy
pkg_version=1.1.8
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('BSD-3-Clause')
pkg_source=https://github.com/google/snappy/archive/${pkg_version}.tar.gz
pkg_shasum=16b677f07832a612b0836178db7f374e414f94657c138e6993cbfc5dcc58651f
pkg_deps=(core/glibc)
pkg_build_deps=(
  core/cmake
  core/gcc
  core/make
  core/libtool
  core/patchelf
)
pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_upstream_url=https://github.com/google/snappy
pkg_description="A fast compressor/decompressor http://google.github.io/snappy/"

do_prepare() {
  __gcc_LD_RUN_PATH="$(pkg_path_for gcc)/LD_RUN_PATH"
  LD_RUN_PATH="${LD_RUN_PATH}:$(cat "${__gcc_LD_RUN_PATH}")"
  export LD_RUN_PATH
}

do_build () {
  libtoolize --force
  mkdir build
  pushd build &>/dev/null || exit 1
    cmake ../
    make
  popd &>/dev/null || exit 1
}

do_install() {
  return 0
}

do_check () {
  patchelf --interpreter "$(pkg_path_for glibc)/lib/ld-linux-x86-64.so.2" \
    --set-rpath "${LD_RUN_PATH}" "${SRC_PATH}/build/snappy_unittest"
  build/snappy_unittest
}
