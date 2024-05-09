module diag 
    use precise
    contains 
    subroutine generate_diagnostics(first, k, new_solution)
        !---------------------------------------------------------------------------
        ! Purpose: Generates diagnostic information during simulation iterations.
        !
        ! Parameters:
        !   - first: Logical flag indicating whether it's the first iteration
        !   - k: Current iteration number
        !   - new_solution: Array containing the updated temperature distribution
        !
        ! Notes:
        !   - If it's the first iteration, create file and write the minimum temperature.
        !   - Every 10th iteration, update the minimum temperature in the file.
        !---------------------------------------------------------------------------
    
        logical :: first
        integer :: k
        real(mkd) :: minimum
        real(mkd), dimension(:, :) :: new_solution
    
        if (first) then
            first = .FALSE.
            open(10, file='diagnostics.dat')
            minimum = minval(new_solution)
            write(10, '(3E12.4)') minimum
        end if
    
        if (mod(k, 10) == 0) then
            minimum = minval(new_solution)
            write(10, '(3E12.4)') minimum
        end if
    end subroutine generate_diagnostics
    
end module diag