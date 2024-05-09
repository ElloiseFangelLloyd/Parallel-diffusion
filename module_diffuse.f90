module diffuse
    use precise
    implicit none
    contains 

    subroutine solve_for_temp(delta_t, delta_x, delta_y, D, old_solution, new_solution, nx, ny)
        !---------------------------------------------------------------------------
        ! Purpose: Solves the heat equation for temperature distribution over time.
        !
        ! Parameters:
        !   - delta_t: Time step (change in time)
        !   - delta_x: Grid spacing in the x-direction
        !   - delta_y: Grid spacing in the y-direction
        !   - D: Thermal diffusivity coefficient
        !   - old_solution: Array containing the temperature distribution at the previous time step
        !   - new_solution: Array to store the updated temperature distribution
        !   - nx: Number of grid points in the x-direction
        !   - ny: Number of grid points in the y-direction
        !
        ! Notes:
        !   - The heat equation is discretized using finite differences.
        !   - The Laplacian operator is approximated using central differences.
        !   - The new temperature at each grid point is computed based on the old solution.
        !---------------------------------------------------------------------------
    
        integer :: D 
        real :: delta_x, delta_y
        double precision :: delta_t 
        real(mkd), dimension(:, :) :: old_solution
        real(mkd), dimension(:, :) :: new_solution
        integer :: nx, ny
        integer :: i, j
    
        DO j = 2, ny-1
            DO i = 2, nx-1
                ! Compute the Laplacian terms using central differences
                real(mkd) :: laplacian_x, laplacian_y
                laplacian_x = (old_solution(i+1, j) - 2 * old_solution(i, j) + old_solution(i-1, j)) / (delta_x**2)
                laplacian_y = (old_solution(i, j+1) - 2 * old_solution(i, j) + old_solution(i, j-1)) / (delta_y**2)
    
                ! Update the temperature at the current grid point
                new_solution(i, j) = old_solution(i, j) + (delta_t * D * (laplacian_x + laplacian_y))
            END DO
        END DO
    end subroutine solve_for_temp
    

    subroutine update_old_field(nx, ny, old_solution, new_solution)
        !---------------------------------------------------------------------------
        ! Purpose: Updates the old temperature field with the new temperature field.
        !
        ! Parameters:
        !   - nx: Number of grid points in the x-direction
        !   - ny: Number of grid points in the y-direction
        !   - old_solution: Array containing the temperature distribution at the previous time step
        !   - new_solution: Array containing the updated temperature distribution
        !
        ! Notes:
        !   - The equation uses the old field to set the new field, so we update the old field every timestep.
        !   - This subroutine is typically called after solving for the new temperature distribution.
        !---------------------------------------------------------------------------
    
        integer :: nx, ny
        real(mkd), dimension(:, :) :: old_solution
        real(mkd), dimension(:, :) :: new_solution
        integer :: i, j
    
        DO j = 2, ny-1
            DO i = 2, nx-1
                ! Update the old temperature field with the new temperature values
                old_solution(i, j) = new_solution(i, j)
            END DO
        END DO
    end subroutine update_old_field
    

end module diffuse 