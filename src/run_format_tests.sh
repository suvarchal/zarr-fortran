rm -f ./zarr_format_tests
gfortran -c zarr_util.F90
gfortran -c zarr_format_tests.F90
gfortran -o zarr_format_tests zarr_format_tests.o zarr_util.o
./zarr_format_tests
