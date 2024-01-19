PROGRAM diffusion_parallel
    use inputs
    use diffuse 
    use setup
    use output
    use precise
    use timings
    use diag
    use mpi

    implicit none

    ! MPI variables
    integer :: rank, size, ierr
    integer, parameter :: root = 0
    integer :: local_nx, local_ny

    ! need two fields to solve the diffusion equation, for n-1 and n (as in exercise guidelines)
    ! initialise two arrays of temperature values 
    ! type mkd is in module_precise, to change between single and double precision 
    real(mkd), dimension(:, :), allocatable :: old_solution_local, new_solution_local
    real(mkd), dimension(:, :), allocatable :: old_solution, new_solution

    ! info for initialization, k is a loop counter
    integer :: info, k

    ! determines whether or not to open a file for diagnostic data
    logical :: first = .TRUE.

    ! MPI initialization
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Calculate local domain size
    local_nx = nx / size
    local_ny = ny

    call initialise_fields(nx, ny, old_solution, new_solution, info)

    ! Allocate and initialize local temperature fields
    allocate(old_solution_local(local_nx, local_ny))
    allocate(new_solution_local(local_nx, local_ny))

    ! Scatter the global fields among processes
    call MPI_Scatter(old_solution, local_nx * local_ny, MPI_REAL8, old_solution_local, &
                    local_nx * local_ny, MPI_REAL8, root, MPI_COMM_WORLD, ierr)
    call MPI_Scatter(new_solution, local_nx * local_ny, MPI_REAL8, new_solution_local, &
                    local_nx * local_ny, MPI_REAL8, root, MPI_COMM_WORLD, ierr)

    ! Read input file and update the dummy arguments with data from the file (only root process)
    if (rank == root) then
        call initialise_from_data(nx, ny, D, iter, delta_t)
        call initialise_deltas(delta_x, delta_y, Lx, Ly, nx, ny)
        call initialise_fields(nx, ny, old_solution, new_solution, info)
    endif

    ! Broadcast the global input data to all processes
    call MPI_Bcast(delta_t, 1, MPI_REAL8, root, MPI_COMM_WORLD, ierr)
    call MPI_Bcast(delta_x, 1, MPI_REAL8, root, MPI_COMM_WORLD, ierr)
    call MPI_Bcast(delta_y, 1, MPI_REAL8, root, MPI_COMM_WORLD, ierr)
    call MPI_Bcast(D, 1, MPI_REAL8, root, MPI_COMM_WORLD, ierr)

    k = 0
    DO WHILE (k < 200)
        ! For printing diagnostic data; see module_diag
        !call generate_diagnostics(first, k, new_solution_local)

        ! Solve the actual diffusion equation locally
        call solve_for_temp(delta_t, delta_x, delta_y, D, old_solution_local, new_solution_local, local_nx, local_ny)

        ! Gather the local solutions to the root process
        call MPI_Gather(new_solution_local, local_nx * local_ny, MPI_REAL8, new_solution, &
                        local_nx * local_ny, MPI_REAL8, root, MPI_COMM_WORLD, ierr)

        ! Set the old field equal to the new updated solutions globally
        if (rank == root) then
            call update_old_field(nx, ny, old_solution, new_solution)
        endif

        ! Print data out (only on root process)
        !if (rank == root) then
        !    call print_data(nx, ny, delta_x, delta_y, new_solution, iter)
        !endif

        k = k + 1
    END DO

    ! Stops the timer and calculates the walltime and CPU time; prints
    call stop_timer(count_final, count_rate, cpu_time_end)
    call print_runtimes(count, count_final, count_rate, cpu_time_start, cpu_time_end, wall_time)


    ! MPI finalization
    call MPI_Finalize(ierr)
END PROGRAM diffusion_parallel
