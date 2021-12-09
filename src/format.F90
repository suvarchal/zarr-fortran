	PROGRAM main
         use iso_c_binding
	 IMPLICIT NONE

	 REAL    :: F = 123.456789
         Integer :: iv =100, funit=9700
         character(len=100) :: test_str, form_str
         integer :: ivals(3) = [1,2,3], i, j 
         character(len=13) :: machine_endian
         real, allocatable    :: arr_2d(:,:)

         !inquire(unit=newunit, convert=machine_endian)
         open(unit=funit, file='dummy', form="unformatted") ! works even for formatted
         !open(newunit=funit, status='scratch') ! creates in tmp
         inquire(funit, convert=machine_endian)
         if (machine_endian == 'BIG_ENDIAN') then 
                print *, "endian :"//machine_endian//", format: <"
         else if (machine_endian == 'LITTLE_ENDIAN') then
                print *, "endian :"//machine_endian//", format: >"
         else
                print *, "unsupported format, use convert in open"//machine_endian
         end if 
         close(unit=funit)
         
         
         write (*,'("""c="""I0)')  iv
         write (test_str,'("""c:"""I0)')  iv
         print *, test_str
        
         print *, 'print sizes'
         print *, sizeof(F)
         print *, c_sizeof(F)
         print *, 'print array sizes'
         print *, sizeof(ivals)
         print *, 'print int sizes'
         print *, sizeof(iv)
         !array
         write (*,'("""c""" ":[" 2(I0",") "]" )')  10,11
         !array without known size, use * but doesn't print ] afterwards
         write (*,'("""c""" ":[" (*(I20",")) "]" )')  10,11
        
         write(test_str,'(I0)') 3
         form_str = '( "["'//trim(test_str)//'(I0",") "]" )'
         print *, '****TESTTTT STR:', form_str
         write (*,form_str) 11, 12, 13
         
         print *, 'lEN', len([character(10):: "test","test2"])
         !write (*,'( ((A),) )') ["test1", "test2"]
         stop
         !check how to initialize 2darray
         !allocate(arr_2d(10,10))
         !arr_2d(:,:) =(/((i, i=1,10), j=1,10)/)
         !print *, 'array 2d', shape([((i, i=1,10), j=1,10)]) ! always creates 1d array so reshape
         !print *, 'array 2d', reshape([((i, i=1,10), j=1,10)], (/10,10/)) ! always creates 1d array so reshape
         arr_2d=reshape([((i, i=1,10), j=1,10)], (/10,10/)) 
         print *, 'arr 2d shape', shape(arr_2d)
         print *, 'arr 2d vals', arr_2d(0,:)

         write (*,*) '------------' 
         !write (form_str,'("""c""" ":[" I0(I0",")) "]" )')  2
         form_str = '(*(I0,:,"'//achar(9)//'"))'
         write (*,form_str)  ivals
         write (*,*) '------------' 
         
         !write (form_str,'("""c""" ":[" I0(I0",")) "]" )')  2
         form_str = '("[" *(I0,:,"'//','//'") "'//']'//'" )'
         write (*,form_str)  ivals
         write (*,*) '------------' 
         !append to samestr
         test_str = test_str // 'hello' !doesn't work?
         print *, test_str

         test_str = 'hello' // test_str
         print *, test_str
	 print '(F7.2, 4X, F7.2)',   F, F, F, F, F, F, F, F

	 print *, "------------------"

	 print '(F7.2, 4X, (F7.2))', F, F, F, F, F, F, F, F



	END
