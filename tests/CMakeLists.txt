# This is the CMake build file for the test directory of NCEPLIBS-w3emc.

# Kyle Gerheiser, Ed Hartnett

if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel)$")
  set(CMAKE_Fortran_FLAGS "-g -O3 -assume noold_ldout_format -convert big_endian")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^(GNU)$")
  set(CMAKE_Fortran_FLAGS "-fdefault-real-8 -fno-range-check -g -O0 -fbacktrace -fcheck=bounds")
endif()

find_package(bacio CONFIG)
find_package(w3nco CONFIG)

execute_process(COMMAND cmake -E create_symlink
  "${CMAKE_CURRENT_SOURCE_DIR}/data"
  "${CMAKE_CURRENT_BINARY_DIR}/data" # New name
  )

add_executable(test_w3emc test_w3emc.f90)

target_link_libraries(test_w3emc w3emc::w3emc_4 bacio::bacio_4 w3nco::w3nco_4)


add_test(test_w3emc test_w3emc  "data/gfs.t00z.pgrb2.0p25.f012_grib1.idx" "gfs.t00z.pgrb2.0p25.f012_grib1")
