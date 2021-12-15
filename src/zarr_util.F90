module zarr_util
implicit none
private
public :: get_zgroup_json, get_zattrs_json, get_zarray_json, byteorder

!interface write_dataarray
!   module procedure write_real_1darray, write_real_2darray!, write_real3darray, write_real4darray,  &
!                    !write_real_4darray, write_real_6darray         
!end interface write_dataarray

contains
  !best function or subroutine? right now it is function like disguised in subroutine
  !can really do better to do DRY keep appending to existing json string using subroutine
  ! but that dependson how these utils will be used
  ! use allocated to decideifnewkey has to be appended or not
  ! note may need to wrap datatypes of dummy args, say for arrays (i8->i4) using transfer?
  subroutine  get_zgroup_json(json_text)
     !character(len=:), allocatable, intent(out) :: json_text !ifallocatedhere
          character(len=*), intent(out) :: json_text !if alloc in calling routine
     !integer :: fileunit
     json_text = '{"zarr_format": 2}'
     !open(newunit=fileunit)
     !write(fileunit, '(a)') trim(text)
  end subroutine get_zgroup_json 

  ! this one is terrible, should and can do elegantly
  subroutine get_zattrs_json(json_text, attrs)
     character(len=*), intent(in), optional :: attrs
     !character(len=:), allocatable, intent(out) :: json_text
     character(len=*), intent(out) :: json_text
     ! can attrs be better represented
     if (present(attrs)) then     
        json_text = attrs
     else
        json_text = "{}"
     end if 
  end subroutine get_zattrs_json 

  subroutine get_zarray_json(json_text, chunks, array_shape, dtype, fill_value, order, compressor, filters)
     integer, intent(in) :: chunks(:), array_shape(:)
     character(len=*), intent(in) :: dtype
     real, intent(in), optional  :: fill_value !kind?
     character(len=*), intent(in), optional :: order, compressor, filters
     !character(len=:), allocatable, intent(out) :: json_text ! assume it was allocated already
     character(len=*), intent(out) :: json_text ! assume it was allocated already
     character(len=999) :: tmp_text ! or allocate and deallocate
     
     json_text = "{"
      
     write(tmp_text,'(*(I0,:,","))') chunks ! use of ,:, avoids trailing ,
     !no , at start for first one
     tmp_text = '"chunks":[' // adjustl(trim(tmp_text)) // ']' 
     json_text= adjustl(trim(json_text)) // tmp_text
     
     
     write(tmp_text,'(*(I0,:,","))') array_shape
     tmp_text = ',"shape":[' // adjustl(trim(tmp_text)) //']'  
     json_text= adjustl(trim(json_text)) // tmp_text
     

     !dtype should be inferred from data
     !print *, dtype
     tmp_text = ',"dtype":"' // trim(dtype) //'"'     
     json_text = adjustl(trim(json_text)) // tmp_text


     if (present(fill_value)) then
         write(tmp_text,'(F5.2)') fill_value !use E form?
         tmp_text = ',"fill_value":' // adjustl(trim(tmp_text)) 
     else 
         tmp_text = ',"fill_value":null'
     end if
     json_text = adjustl(trim(json_text)) // tmp_text
     

     ! usually F but just in case  
     if (present(order)) then
        tmp_text = ',"order":"' // adjustl(trim(order)) //'"'     
     else
        tmp_text = ',"order":"F"'
     end if        
     json_text = adjustl(trim(json_text)) // tmp_text


     if (present(compressor)) then
         tmp_text = ',"compressor":"'//adjustl(trim(compressor))//'"'   
     else 
         tmp_text = ',"compressor":null'
     end if
     json_text = adjustl(trim(json_text)) // tmp_text


     if (present(filters)) then
         tmp_text = ',"filters":"'//adjustl(trim(filters))//'"'   
     else 
         tmp_text = ',"filters":null'
     end if
     json_text = adjustl(trim(json_text)) // tmp_text


     ! append zarr format
     tmp_text = ',"zarr_format":2'
     json_text = adjustl(trim(json_text)) // tmp_text
     
     ! end }
     json_text = adjustl(trim(json_text)) // "}"
      

!     json_text = '{"chunks": [100], "compressor": null, "dtype": "<f4", "fill_value": 0.0, "filters": null, "order": "F", &
!    "shape": [ &
!        100 &
!    ], &
!    "zarr_format": 2 &
!}'

  end subroutine get_zarray_json 

!module procedure write_real_1darray, write_real_2darray, write_real3darray, write_real4darray,  &
!                    write_real_4darray, write_real_6darray         
!  subroutine write_real_1darray(filename, array)
!          implicit none
!          character(len=*), intent(in) :: filename
!          real(
!  end subroutine write_real_1darray

  function byteorder()
    integer :: fileunit
    character(13) :: endian_string
    character     :: byteorder
    open(newunit=fileunit, status="scratch")
    inquire(fileunit, convert=endian_string)
    if (endian_string=="LITTLE_ENDIAN") then
          byteorder = "<"
    else if (endian_string=="BIG_ENDIAN") then
          byteorder = ">"
    else
         print *, "byteorder of machine is unknown, using little endian, use convert option in open to encode data in little endian" 
         byteorder = "<"
    end if
  end function byteorder
end module zarr_util 
