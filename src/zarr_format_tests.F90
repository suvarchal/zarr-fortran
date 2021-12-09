program zarr_format_tests
use zarr_util  
implicit none
character(len=:),allocatable :: zgroupstr, zattrsstr
character(len=9999):: zarraystr
integer :: i
real, dimension(100) :: arr_data
real, dimension(10,20,30) :: arr_data2
!integer, dimension(len(shape(arr_data))) :: chunks(:), array_shape(:)
character(9) :: dtype="<f4"


call get_zgroup_json(zgroupstr)
print *, zgroupstr 

call get_zattrs_json(zattrsstr)
print *, zattrsstr 

arr_data = [(i, i=1,100)]

print *, dtype
!call get_zarray_json(zarraystr, shape(arr_data), shape(arr_data), trim(dtype))
call get_zarray_json(zarraystr, shape(arr_data), shape(arr_data), "<f4")
print *, trim(zarraystr) 


!     json_text = '{"chunks": [100], "compressor": null, "dtype": "<f4", "fill_value": 0.0, "filters": null, "order": "F", &
!    "shape": [ &
!        100 &
!    ], &
!    "zarr_format": 2 &
!}'


end program zarr_format_tests
