program write_zarr
use zarr_util
implicit none
integer :: fileunit,i, rec_array
character(len=9999) :: root, filename, dirnames, text, zgroup, zarray, tmp
character(len=9):: dtype='<f4'
real :: rdata(100)
real :: rdata_chunk(50)
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
close(fileunit)


tmp=trim(root)//"/zda/.zarray"
open(newunit=fileunit, file=trim(tmp))
!text='{"chunks": [100], "compressor": null, "dtype": "<f4", "fill_value": 0.0, "filters": null, "order": "F", &
!    "shape": [ &
!        100 &
!    ], &
!    "zarr_format": 2 &
!}'
print *, shape(rdata), sizeof(rdata), kind(rdata), rank(rdata)!, precision(rdata)
print *, [1, (shape(rdata))]

!************************************
! WHAT IF WE DONT KNOW the number of times we write before hand? here used 2
!call get_zarray_json(text, [1,(shape(rdata))],[2,(shape(rdata))], "<f4") !dtype)
call get_zarray_json(text, [1,50],[2,(shape(rdata))], "<f4") !dtype) !checking if chunks dont add up
!this below using big number doesn't work
!call get_zarray_json(text, [1,(shape(rdata))],[1000,(shape(rdata))], "<f4") !dtype)
! do we need to consolidate in that case??


write(fileunit, '(a)') trim(text)
flush(fileunit)
close(fileunit)

tmp=trim(root)//"/zda/.zattrs"
open(newunit=fileunit, file=trim(tmp))
text = '{"_ARRAY_DIMENSIONS":["time","nod2d"]}'
write(fileunit, '(a)') trim(text)
flush(fileunit)
close(fileunit)



tmp=trim(root)//"/zda/0.0"
open(newunit=fileunit, file=trim(tmp), form="unformatted", access='stream', action='write') !, recl=rec_array)
!rdata = [(i, i=401,500)]
rdata_chunk = [(i, i=1,50)]
!write(fileunit) rdata
write(fileunit) rdata_chunk
flush(fileunit)
close(fileunit)

!chunk in space
tmp=trim(root)//"/zda/0.1"
open(newunit=fileunit, file=trim(tmp), form="unformatted", access='stream', action='write') !, recl=rec_array)
rdata_chunk = [(i, i=51,100)]
write(fileunit) rdata_chunk
flush(fileunit)
close(fileunit)

tmp=trim(root)//"/zda/1.0"
open(newunit=fileunit, file=trim(tmp), form="unformatted", access='stream', action='write') !, recl=rec_array)
!rdata = [(i, i=501,600)]
rdata_chunk = [(i, i=101,150)]
!write(fileunit) rdata
write(fileunit) rdata_chunk
flush(fileunit)
close(fileunit)

!chunk in space time =2
tmp=trim(root)//"/zda/1.1"
open(newunit=fileunit, file=trim(tmp), form="unformatted", access='stream', action='write') !, recl=rec_array)
rdata_chunk = [(i, i=151,200)]
!write(fileunit) rdata
write(fileunit) rdata_chunk
flush(fileunit)
close(fileunit)

end program write_zarr
