require 'sys/proctable'
require 'pp'
include Sys

ProcTable.ps{ |proc_struct|
 puts proc_struct.comm if /proc_struct.comm/.match('bash')
}

