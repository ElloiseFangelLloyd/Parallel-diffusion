MODULE bounds 
    use precise
    use mpi

    implicit none
    contains 

    SUBROUTINE update_boundaries(new_solution_local, rank, local_nx, local_ny)

    !--------------------------------------------------------------
    ! Purpose:    Updates boundary values in a parallel simulation
    ! Parameters:
    !   - new_solution_local: 2D array (local solution data)
    !   - rank: process rank (within MPI_COMM_WORLD)
    !   - local_nx, local_ny: dimensions of the local data grid
    !--------------------------------------------------------------
        INTEGER, INTENT(IN) :: local_nx, local_ny, rank
        REAL(mkd), DIMENSION(:, :), INTENT(INOUT) :: new_solution_local
    
        ! Assuming there are two neighboring processes: left_neighbor and right_neighbor
        INTEGER :: left_neighbor, right_neighbor, ierr
        INTEGER :: maxrank
    
        ! Identify neighboring processes
        left_neighbor = rank - 1
        right_neighbor = rank + 1
    
        CALL MPI_Comm_size(MPI_COMM_WORLD, maxrank, ierr)
    
        ! Check if neighbors are within valid ranks
        IF (left_neighbor < 0) THEN
            left_neighbor = MPI_PROC_NULL
        ENDIF
    
        IF (right_neighbor >= maxrank) THEN
            right_neighbor = MPI_PROC_NULL
        ENDIF
    
        ! Exchange boundaries using MPI_Sendrecv
        IF (left_neighbor /= MPI_PROC_NULL) THEN
            CALL MPI_Sendrecv(new_solution_local(:, 1), local_ny, MPI_REAL8, left_neighbor, 0, &
                                new_solution_local(:, 1), local_ny, MPI_REAL8, left_neighbor, 1, & 
                                MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
        ENDIF
    
        IF (right_neighbor /= MPI_PROC_NULL) THEN
            CALL MPI_Sendrecv(new_solution_local(:, local_nx), local_ny, MPI_REAL8, right_neighbor, 1, &
                                new_solution_local(:, local_nx + 1), local_ny, MPI_REAL8, right_neighbor, 0, & 
                                MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
        ENDIF

    
    END SUBROUTINE update_boundaries
    
    
    
    

end module bounds 