from datetime import datetime

# Input
ts1_str = input()
ts2_str = input()

# Define the format
fmt = "%d-%m-%Y %H:%M:%S"

# Convert strings to datetime objects
ts1 = datetime.strptime(ts1_str, fmt)
ts2 = datetime.strptime(ts2_str, fmt)

# Calculate difference in seconds
diff = abs((ts1 - ts2).total_seconds())

# Output as integer
print(int(diff))
