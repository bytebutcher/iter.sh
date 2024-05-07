# iter.sh

iter.sh is a flexible and powerful shell script designed to simplify the processing of structured text files in a UNIX-like environment. 

## Usage

```
iter.sh [-f file] [-d delimiter] [-c column_names] <command>
```

## Examples

```
# Pipe into iter and print every line of a csv file
cat data.txt | iter.sh -d ',' -c 'name,namespace' 'echo $name is in $namespace'
```

```
# Print every line of a csv file
iter.sh -f data.txt -d ',' -c 'name,namespace' 'echo $name is in $namespace'
```

```
# Print every line of a text file
iter.sh -f data.txt 'echo $line'
```
