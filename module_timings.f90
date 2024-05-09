module timings 
    character(8) :: date
    character(10) :: time
    character(5) :: zone
    double precision :: wall_time
    double precision :: cpu_time_start 
    double precision :: cpu_time_end 
    integer :: count 
    integer :: count_final
    integer :: count_rate 
contains 



subroutine print_runtimes(count, count_final, count_rate, cpu_time_start, cpu_time_end, wall_time)

    !--------------------------------------------------------------
    ! Purpose:    Prints wall time and CPU time information
    ! Parameters:
    !   - count: initial clock value (e.g., start of simulation)
    !   - count_final: final clock value (e.g., end of simulation)
    !   - count_rate: clock rate (ticks per second)
    !   - cpu_time_start: CPU time at the start of the measurement
    !   - cpu_time_end: CPU time at the end of the measurement
    !--------------------------------------------------------------
    double precision :: wall_time
    double precision :: cpu_time_start
    double precision :: cpu_time_end
    double precision :: cpu_total
    integer :: count
    integer :: count_final
    integer :: count_rate

    ! Calculate wall time (elapsed real time)
    wall_time = (dble(count_final) - dble(count)) / dble(count_rate)
    print*, 'Walltime is: ', wall_time, ' seconds'

    ! Calculate CPU time
    cpu_total = cpu_time_end - cpu_time_start
    print*, 'CPU time is: ', cpu_total, ' seconds'
end subroutine print_runtimes



subroutine print_date_time()
    !--------------------------------------------------------------
    ! Purpose:    Prints the current date and time
    ! Parameters: None (no input parameters)
    !--------------------------------------------------------------
    character(8) :: date
    character(10) :: time
    character(5) :: zone

    ! Get the current date and time
    call date_and_time(date, time, zone)

    ! Print the date in the format: DD/MM/YYYY
    print*, 'The date is: ', date(7:8), '/', date(5:6), '/', date(1:4)

    ! Print the time in the format: HH:MM.SS
    print*, 'The time is: ', time(1:2), ':', time(3:4), '.', time(5:6)
end subroutine print_date_time

subroutine start_timer(count, cpu_time_start)

    !--------------------------------------------------------------
    ! Purpose:    Starts a timer for measuring CPU time
    ! Parameters:
    !   - count: initial clock value (e.g., start of simulation)
    !   - cpu_time_start: variable to store CPU time at start
    !--------------------------------------------------------------
    integer :: count
    double precision :: cpu_time_start

    ! Get the initial clock value
    call system_clock(count)

    ! Get the CPU time at the start
    call cpu_time(cpu_time_start)
end subroutine start_timer

subroutine stop_timer(count_final, count_rate, cpu_time_end)
    !--------------------------------------------------------------
    ! Purpose:    Stops a timer and calculates CPU time
    ! Parameters:
    !   - count_final: final clock value (e.g., end of simulation)
    !   - count_rate: clock rate (ticks per second)
    !   - cpu_time_end: variable to store CPU time at end
    !--------------------------------------------------------------
    integer :: count_final, count_rate
    double precision :: cpu_time_end

    ! Get the final clock value and clock rate
    call system_clock(count_final, count_rate)

    ! Get the CPU time at the end
    call cpu_time(cpu_time_end)
end subroutine stop_timer

end module timings