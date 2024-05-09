module output
    use precise
implicit none
contains 

subroutine print_data(nx, ny, delta_x, delta_y, new_solution, k)
!--------------------------------------------------------------
! Purpose:    Writes data to a file in a specified format
! Parameters:
!   - nx, ny: dimensions of the data grid
!   - delta_x, delta_y: grid spacing in x and y directions
!   - new_solution: 2D array containing the solution data
!   - k (optional): an integer identifier for the output file
!   - filename: name of the output file
!--------------------------------------------------------------
    integer :: nx, ny
    real :: delta_x, delta_y
    real(mkd), dimension(:, :), allocatable :: new_solution
    integer, optional :: k
    character(len = 100) :: filename 
    integer :: i, j

    ! Determine the output filename based on the optional k value
    IF (present(k)) THEN
        WRITE(filename, fmt='(A,I4.4,A)') 'diff_', k, '.dat'
    ELSE 
        filename = 'diff.dat'
    END IF

    ! Open the output file
    OPEN(k, file=filename)

    ! Write data to the file
    DO j = 1, ny
        DO i = 1, nx
            WRITE(k, '(3E12.4)') REAL(i-1) * delta_x, REAL(j-1) * delta_y, new_solution(i, j)
        END DO
        WRITE(k, '(A)') ! Write an empty line after each row
    END DO
    
    ! Close the output file
    CLOSE(k)
end subroutine print_data
end module output