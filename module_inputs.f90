module inputs
    implicit none
    integer :: D = 1
    integer :: nx = 21
    integer :: ny = 21
    integer :: iter !number of iterations
    real :: Lx = 1
    real :: Ly = 1
    real :: delta_x
    real :: delta_y 
    double precision :: delta_t = 0.000625
    contains 

    subroutine initialise_deltas(delta_x, delta_y, Lx, Ly, nx, ny)
    !---------------------------------------------------------------------------
    ! Purpose: Initializes grid spacing (deltas) for a numerical simulation.
    !
    ! Parameters:
    !   - delta_x: Grid spacing in the x-direction
    !   - delta_y: Grid spacing in the y-direction
    !   - Lx: Length of the domain in the x-direction
    !   - Ly: Length of the domain in the y-direction
    !   - nx: Number of grid points in the x-direction
    !   - ny: Number of grid points in the y-direction
    !
    ! Notes:
    !   - Computes delta_x and delta_y based on the given domain lengths and grid sizes.
    !   - Assumes a uniform grid with equally spaced points.
    !---------------------------------------------------------------------------
        integer :: nx 
        integer :: ny
        real :: Lx
        real :: Ly 
        real :: delta_x
        real :: delta_y 
        delta_x = Lx  / (nx - 1)
        delta_y = Ly / (ny - 1)
    end subroutine initialise_deltas

    subroutine initialise_from_data(nx, ny, D, iter, delta_t) 
    !---------------------------------------------------------------------------
    ! Purpose: Initializes simulation parameters from an input data file.
    !
    ! Parameters:
    !   - nx: Number of grid points in the x-direction
    !   - ny: Number of grid points in the y-direction
    !   - D: Thermal diffusivity coefficient
    !   - iter: Total number of iterations
    !   - delta_t: Time step (change in time)
    !
    ! Notes:
    !   - Reads parameter values from an input data file ("input_data.dat").
    !   - Assumes that the namelist "list" contains the specified variables.
    !---------------------------------------------------------------------------
        integer :: nx, ny, D, iter
        double precision :: delta_t 

        namelist /list/ nx, ny, D, iter, delta_t 
        open(5, file="input_data.dat")
        read(5, nml=list)
    end subroutine initialise_from_data
end module inputs