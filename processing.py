import numpy as np 
import matplotlib.pyplot as plt
from matplotlib import rcParams


rcParams['font.family'] = 'sans-serif'
rcParams['font.size'] = 9
colors = ['blueviolet','violet','hotpink','black']


cores = [1,2,3, 4,5, 6, 7, 8, 10, 12, 14, 16]
times = [19.295, 9.8099, 6.699, 5.077, 4.163, 3.572, 3.117, 2.784, 2.315, 1.977, 1.828, 1.650]


plt.figure() 
plt.plot(cores, times, '^', c=colors[0], linestyle='-')
plt.title('Runtime as a function of number of processors')
plt.xlabel('Number of processors')
plt.ylabel('Runtime (s)')
plt.grid(linestyle='-')
plt.savefig('diffsed_parallel.png',bbox_inches='tight',dpi=150)


speedup = [times[0]/t for t in times]

plt.figure() 
plt.plot(cores, speedup, 'o', c=colors[1], linestyle='-', label='Measured')
plt.plot(cores, cores, c=colors[0], linestyle='--', label='Theoretical')
plt.title('Speedup as a function of number of processors')
plt.xlabel('Number of processors')
plt.ylabel('Speedup')
plt.grid(linestyle='-')
plt.legend()
plt.savefig('diffsed_parallel_speedup.png',bbox_inches='tight',dpi=150)


efficiency = []
for i in range(len(cores)):
    efficiency.append(speedup[i]/cores[i])
    
    
plt.figure() 
plt.plot(cores, efficiency, 'o', c=colors[1], linestyle='-')
plt.title('Efficiency as a function of number of processors')
plt.xlabel('Number of processors')
plt.ylabel('Efficiency')
plt.grid(linestyle='-')
plt.savefig('diffsed_parallel_efficiency.png',bbox_inches='tight',dpi=150)