import os
# Searches clientlog for invalid looksconfig lines and uses those to create list of valid values
# By default mods extract function only dumps looksconfig id's for one lookspackage, but this can handle all lookspackages found in the clientlog
# AddLooksPackage() must be ran twice for every looksconfig to properly log the invalid ones
# After the script is done it will clear the ClientLog

install_path = "G:\SWL\Secret World Legends"
string = "ERROR: RDBLooksPackage - Invalid configuration"
id_index = -1
config_index = 9
size = 50000

arr = []
comp = set(range(0, size))

# Put all id's/configs in array in format array = [[id,config], [id,config], [id,config]]
with open(os.path.join(install_path,"ClientLog.txt"), "r", encoding="utf-8") as f:
	data = f.readlines()
	for line in data:
		if string in line:
			split = line.split(" ")
			arr.append([int(split[id_index]), int(split[config_index])])

# Separate each ID into its own array
newarr = {}
for val in arr:
	if val[0] not in newarr:
		newarr[val[0]] = [val[1]]
	else:
		newarr[val[0]].append(val[1])

# Turn array into set(only unique keys) and get difference to full set -> only valid configs left
for idx in newarr:
	newarr[id].append(0) # 0 is the default value that all packages contain, we dont need that
	newarr[id] = set(newarr[idx])
	diff = newarr[idx].symmetric_difference(comp)
	print(str(id) + "\n" + ", ".join(map(str, diff)))

with open(os.path.join(install_path, "ClientLog.txt"), "w", encoding="utf-8") as f:
	f.write("")