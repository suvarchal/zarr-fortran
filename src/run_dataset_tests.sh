rm -f ./zarr_dataset_tests zarr_util.o zarr_util.mod zarr_dataset_tests.o
rm -rf test2.zarr
gfortran -c zarr_util.F90
gfortran -c zarr_dataset_tests.F90
gfortran -o zarr_dataset_tests zarr_dataset_tests.o zarr_util.o
./zarr_dataset_tests
