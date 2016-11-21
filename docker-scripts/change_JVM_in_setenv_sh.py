#! /usr/bin/python

from optparse import OptionParser
from __builtin__ import True

min_memory = None
max_memory = None
file_path = "/opt/atlassian/confluence/bin/setenv.sh"

def options_valid():
    if min_memory and max_memory:
        if int(min_memory) < int(max_memory):
            return True
        else:
            print "Can't run: min value is bigger than max value."
            return False
    else:
        print "If you want set JVM memory, specify min and max value."
        return False


def line_is_to_change(line):
    if min_memory and "CATALINA_OPTS=" in line and "-Xms" in line and "-Xmx" in line:
        return True
    else:
        return False

def main():
    if options_valid():
        new_content = ""
        infile = open(file_path, "r")
        for line in infile:
            if line_is_to_change(line):
                line = 'CATALINA_OPTS="-Xms'+min_memory+'m -Xmx'+max_memory+'m -XX:+UseG1GC ${CATALINA_OPTS}"\n'
            new_content += line
        infile.close()
        outfile = open(file_path, "w")
        outfile.write(new_content)
        outfile.close()
            

if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option("--min-memory", dest="min_mem")
    parser.add_option("--max-memory", dest="max_mem")
    parser.add_option("--file-path", dest="fpath")
    opt, args = parser.parse_args()
    print opt.max_mem
    if opt.min_mem:
        min_memory = opt.min_mem
    if opt.max_mem:
        max_memory = opt.max_mem
    if opt.fpath:
        file_path = opt.fpath
    main()
    
    
