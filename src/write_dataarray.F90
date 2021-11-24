program write_zarr

implicit none
integer :: fileunit,i, rec_array
character(len=9999) :: filename, dirnames, text, zgroup, zarray, tmp
real :: rdata(100)

dirnames = "test.zarr/zda"
!call system('mkdir -p ' // adjustl(trim(dirname)))
call execute_command_line ('mkdir -p ' // adjustl(trim(dirnames)))

tmp="test.zarr/.zgroup"

open(newunit=fileunit, file=trim(tmp))
text = '{"zarr_format": 2}'
write(fileunit, '(a)') trim(text)
flush(fileunit)


tmp="test.zarr/.zattrs"
open(newunit=fileunit, file=trim(tmp))
text = "{}"
write(fileunit, '(a)') trim(text)
flush(fileunit)

tmp="test.zarr/zda/.zarray"
open(newunit=fileunit, file=trim(tmp))
text='{"chunks": [100], "compressor": null, "dtype": "<f4", "fill_value": 0.0, "filters": null, "order": "F", &
    "shape": [ &
        100 &
    ], &
    "zarr_format": 2 &
}'
write(fileunit, '(a)') trim(text)
flush(fileunit)

tmp="test.zarr/zda/.zattrs"
open(newunit=fileunit, file=trim(tmp))
text = '{"_ARRAY_DIMENSIONS":["time"]}'
write(fileunit, '(a)') trim(text)
flush(fileunit)



tmp="test.zarr/zda/0"
open(newunit=fileunit, file=trim(tmp), form="unformatted", access='stream', action='write') !, recl=rec_array)
rdata = [(i, i=201,300)]
write(fileunit) rdata
flush(fileunit)



end program write_zarr
