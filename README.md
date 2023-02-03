# Meteo

Generate different Graph based on a csv file that has meteo data

To generate a graph, use the command script_meteo.sh on the root folowed by option to specified your graph.
At least one graph option must be use and a file must be precise with -f


					-f file Inputed must be a csv\n
					\n
					--------- Graph type -----------\n
					-t1 Generate a Graph with each station having a min, max and a average of the temperature\n
					-t2 Generate a Graph with hour having a average of the temperature\n
					-t3 Does nott work\n
					\n
					-p1 Generate a Graph with each station having a min, max and a average of the pressure\n
					-p2 Generate a Graph with hour having a average of the pressure\n
					-p3 Does not work\n 
					\n
					-w Generate a Graph of each station with their average wind direction\n
					\n
					-h Generate a Graph of each station with their height\n
					\n
					-m Generate a Graph of each station with their moisture\n
					--------- Filtering -----------\n
					-d yyyy-mm-dd,YYYY-MM-DD Remove Value that are not contain between yyyy-mm-dd and YYYY-MM-DD\n
					-g m,M Remove Value that do not have longitute between m and M\n
					-a m,M Remove Value that do not have latitude between m and M\n
					-A -Z
					--------- Sorting Method -----------\n
          --tab does not work
          --avl sort using AVL method
          --avl sort using ABR method
          
          exit 1 > inpropper use of option
          exit 2 > missing option
