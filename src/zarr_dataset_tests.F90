program write_zarr
use zarr_util
implicit none
integer :: fileunit,i, rec_array
character(len=9999) :: root, filename, dirnames, text, zgroup, zarray, tmp
character(len=9):: dtype='<f4'
real :: rdata(100)
!real :: rdata(100, 100)

root = "test2.zarr"
dirnames = trim(root) // "/zda"
!call system('mkdir -p ' // adjustl(trim(dirname)))
call execute_command_line ('mkdir -p ' // adjustl(trim(dirnames)))

tmp=trim(root)//"/.zgroup"
open(newunit=fileunit, file=trim(tmp))
call get_zgroup_json(text)
write(fileunit, '(a)') trim(text)
flush(fileunit)
close(fileunit)

tmp=trim(root)//"/.zattrs"
open(newunit=fileunit, file=trim(tmp))
call get_zattrs_json(text)
write(fileunit, '(a)') trim(text)
flush(fileunit)


tmp=trim(root)//"/zda/.zarray"
open(newunit=fileunit, file=trim(tmp))
!text='{"chunks": [100], "compressor": null, "dtype": "<f4", "fill_value": 0.0, "filters": null, "order": "F", &
!    "shape": [ &
!        100 &
!    ], &
!    "zarr_format": 2 &
!}'
print *, shape(rdata), sizeof(rdata), kind(rdata), rank(rdata)!, precision(rdata)
call get_zarray_json(text, shape(rdata), shape(rdata), "<f4") !dtype)
write(fileunit, '(a)') trim(text)
flush(fileunit)

tmp=trim(root)//"/zda/.zattrs"
open(newunit=fileunit, file=trim(tmp))
text = '{"_ARRAY_DIMENSIONS":["time"]}'
write(fileunit, '(a)') trim(text)
flush(fileunit)



tmp=trim(root)//"/zda/0"
open(newunit=fileunit, file=trim(tmp), form="unformatted", access='stream', action='write') !, recl=rec_array)
rdata = [(i, i=401,500)]
write(fileunit) rdata
flush(fileunit)



end program write_zarr
